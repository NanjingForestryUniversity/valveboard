/* 
丁坤的阀板程序v1.4-beta1 2022/8/24
经测试，高压时间改为0.2ms
使用的是合肥的阀，1.5A电流需0.2ms的100V(阀标称100V，现场供电为96V)高电压
*/

module valveboard_firmware(
			input sys_clk,  // 20MHz
			input rst_n,
			input line_sclk,
			input line_sen,
			input line_sdata,
			
			output reg [47:0]  signal_high_voltage,
			output reg [47:0]  signal_low_voltage
			
		);
		
	parameter CHANNEL_NUM = 48;
	parameter CHANNEL_NUM_MINUS_1 = CHANNEL_NUM - 1;
	parameter HIGH_VOLTAGE_TIME = 32'd4000;  // 高压时间HIGH_VOLTAGE_TIME / 20MHz = 0.2ms
	parameter HIGH_VOLTAGE_TIME_MINUS_1 = HIGH_VOLTAGE_TIME - 1;
	parameter LONGOPEN_COUNTER_THRESHOLD = 7'd20;  // 一路阀打开超过LONGOPEN_COUNTER_THRESHOLD * 200_000 / 20MHz = 200ms就关闭
	parameter DISCONNECT_FAULT_COUNTER_THRESHOLD = 32'd4_000_000;  // 通讯中断超过FAULT_COUNTER_THRESHOLD / 20MHz = 200ms，就关所有阀
	parameter DISCONNECT_FAULT_COUNTER_THRESHOLD_MINUS_1 = DISCONNECT_FAULT_COUNTER_THRESHOLD - 1;
	parameter DISCONNECT_FAULT_COUNTER_THRESHOLD_PLUS_1 = DISCONNECT_FAULT_COUNTER_THRESHOLD + 1;
	
	
	reg [31:0] i;
	reg [31:0] disconnect_fault_counter;
	reg [0:0] fault_flag [0:7];  // fault_flag支持8类错误信号
	
	
	/**
	 * 维护错误信号
	 */
	wire total_fault_flag = fault_flag[7] | fault_flag[6] | fault_flag[5] | fault_flag[4] | fault_flag[3] | fault_flag[2] | fault_flag[1] | fault_flag[0];
	integer j;
	initial begin
	  for (j = 0; j < 8; j = j + 1) begin
		fault_flag[j] = 1'b0;
	  end
	end
//	/**
//	 * 产生周期为100kHz的posedge_100khz信号，信号高电平持续1个sys_clk
//	 */
//	reg[7:0] cnt_for_posedge_100khz;
//	reg posedge_100khz;
//	always @(posedge sys_clk or negedge rst_n) begin
//		if(!rst_n) begin
//		   cnt_for_posedge_100khz <= 0;
//		end
//		else if(cnt_for_posedge_100khz == 199) begin
//			posedge_100khz <= 1;
//			cnt_for_posedge_100khz <= 0;
//		end
//		else begin
//			cnt_for_posedge_100khz <= cnt_for_posedge_100khz + 1;
//			posedge_100khz <= 0;
//		end                            
//	end

	/**
	 * 在输入的line_sclk信号上升沿产生1个sys_clk时长高电平的脉冲信号posedge_line_sclk，比原信号延迟(4,5]个sys_clk
	 */
	reg [4:0] cache_line_sclk;
	reg posedge_line_sclk;
	always@(posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			cache_line_sclk <= 0;	
			posedge_line_sclk <= 0;
		end
		else begin
			cache_line_sclk <= {cache_line_sclk[3:0], line_sclk};
			if ({cache_line_sclk, line_sclk} == 6'b011111)
				posedge_line_sclk <= 1;
			else
				posedge_line_sclk <= 0;
		end
	end
	
	/**
	 * filter_line_sdata比原信号延迟(4,5]个sys_clk
	 */
	reg [4:0] tmp_cache_line_sdata;
	reg fiter_line_sdata;
	always@(posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			tmp_cache_line_sdata <= ~0;
		end
		else begin
			tmp_cache_line_sdata <= {tmp_cache_line_sdata[3:0], line_sdata};
			fiter_line_sdata <= tmp_cache_line_sdata[4];
		end
	end
	
	/**
	 * 在输入的line_sen信号上升沿产生1个sys_clk时长高电平的脉冲信号posedge_line_sen，比原信号延迟(4,5]个sys_clk
	 * 在输入的line_sen信号下降沿产生1个sys_clk时长高电平的脉冲信号negedge_line_sen，比原信号延迟(4,5]个sys_clk
	 * 缓存和整理line_sen信号得filter_line_sen，比原信号延迟(4,5]个sys_clk
	 */
	reg [4:0] cache_line_sen;
//	reg posedge_line_sen;
	reg filter_line_sen;
	reg negedge_line_sen;
	always@(posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			cache_line_sen <= 0;
			filter_line_sen <= 0;
//			posedge_line_sen <= 0;
		end
		else begin
			cache_line_sen <= {cache_line_sen[3:0], line_sen};
			if ({cache_line_sen, line_sen} == 6'b011111) begin
//				posedge_line_sen <= 1;
				filter_line_sen <= 1;
				negedge_line_sen <= 0;
			end
			else if ({cache_line_sen, line_sen} == 6'b100000) begin
//				posedge_line_sen <= 0;
				filter_line_sen <= 0;
				negedge_line_sen <= 1;
			end
			else begin
//				posedge_line_sen <= 0;
				filter_line_sen <= filter_line_sen;
				negedge_line_sen <= 0;
			end
		end
	end
	
	/**
	 * line_clk上升沿采样line_sdata，采样时刻与posedge_line_sclk下降沿对齐
	 * total_fault_flag会相对line_clk异步结束本次通信
	 * recv_complete指示是否接收完成，单sys_clk周期宽度，与negedge_line_sen信号对齐
	 */
	reg [CHANNEL_NUM_MINUS_1:0] cache_line_sdata;
	wire recv_complete = negedge_line_sen && (i == CHANNEL_NUM);
	always @ (posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			i <= 0;
			cache_line_sdata <= ~0;
		end
		else if (total_fault_flag) begin
			i <= 0;
			cache_line_sdata <= ~0;
		end
		else if (filter_line_sen && posedge_line_sclk) begin
			cache_line_sdata[i] <= fiter_line_sdata; 
			i <= i + 1;  
		end
		else if (negedge_line_sen) begin
			i <= 0;
		end
	end
	
	/**
	 * 若接收超过CHANNEL_NUM个数据，产生错误信号fault_flag[0]；fault_flag[0]将在posedge_line_sen上升沿时刻清楚
	 */
	always @ (posedge sys_clk or negedge rst_n) begin
		if (!rst_n)
			fault_flag[0] <= 0;
		else if (i > CHANNEL_NUM)
			fault_flag[0] <= 1;
		else if ({cache_line_sen, line_sen} == 6'b011111)
			fault_flag[0] <= 0;
		else
			fault_flag[0] <= fault_flag[0];
	end
	 
	/**
	 * 若通讯中断，超过DISCONNECT_FAULT_COUNTER_THRESHOLD个csys_clk就置位fault_flag[1]
	 * fault_flag[1]在posedge_line_sclk上升沿时刻清楚
	 */
	always @(posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			disconnect_fault_counter <= 0;
			fault_flag[1] <= 0;
		end
		else if ({cache_line_sclk, line_sclk} == 6'b011111) begin
			disconnect_fault_counter <= 0;
			fault_flag[1] <= 0;
		end
		else begin
			if (disconnect_fault_counter >= DISCONNECT_FAULT_COUNTER_THRESHOLD_PLUS_1)
				fault_flag[1] <= 1;
			else if (disconnect_fault_counter >= DISCONNECT_FAULT_COUNTER_THRESHOLD_MINUS_1) begin
				disconnect_fault_counter <= disconnect_fault_counter + 1;
				fault_flag[1] <= 1;
			end
			else begin
				disconnect_fault_counter <= disconnect_fault_counter + 1;
				fault_flag[1] <= 0;
			end
		end
	end
	
	
	/**
	 * 得到enable_count_high_voltage_time的上升沿脉冲posedge_enable_count_high_voltage_time
	 * enable_count_high_voltage_time是用于开启高电压计时的信号，在其上升沿开启计时
	 */
	reg [1:0] cache_enable_count_high_voltage_time;
	reg enable_count_high_voltage_time;
	wire posedge_enable_count_high_voltage_time = cache_enable_count_high_voltage_time[0] & ~cache_enable_count_high_voltage_time[1];
	always @(posedge sys_clk or negedge rst_n) begin
		if (!rst_n)
			cache_enable_count_high_voltage_time <= 0;
		else begin
			cache_enable_count_high_voltage_time[0] <= enable_count_high_voltage_time;
			cache_enable_count_high_voltage_time[1] <= cache_enable_count_high_voltage_time[0];
		end
	end
	
	/**
	 * posedge_enable_count_high_voltage_time下降沿开始从HIGH_VOLTAGE_TIME-1向下计数，count_high_voltage_time_end上升沿与到0瞬间对齐
	 * is_high_voltage_time表示当前是否需要输出高电平，其宽度为HIGH_VOLTAGE_TIME
	 * posedge_count_high_voltage_time_complete脉冲时长为一个sys_clk
	 */
	reg [31:0] cnt_for_high_voltage_time;
//	reg high_voltage_time_end;
	reg is_high_voltage_time;
	always @(posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt_for_high_voltage_time <= 0;
//			high_voltage_time_end <= 0;
			is_high_voltage_time <= 0;
		end
		else if (total_fault_flag) begin
			cnt_for_high_voltage_time <= 0;
//			high_voltage_time_end <= 0;
			is_high_voltage_time <= 0;
		end
		else if (posedge_enable_count_high_voltage_time) begin
			cnt_for_high_voltage_time <= HIGH_VOLTAGE_TIME_MINUS_1;
//			high_voltage_time_end <= 0;
			is_high_voltage_time <= 1;
		end
		else if (cnt_for_high_voltage_time > 1) begin
			cnt_for_high_voltage_time <= cnt_for_high_voltage_time - 1;
//			high_voltage_time_end <= 0;
			is_high_voltage_time <= 1;
		end
		else if (cnt_for_high_voltage_time == 1) begin
			cnt_for_high_voltage_time <= cnt_for_high_voltage_time - 1;
//			high_voltage_time_end <= 1;
			is_high_voltage_time <= 1;
		end
		else begin
//			high_voltage_time_end <= 0;
			is_high_voltage_time <= 0;
		end
	
	end

	/**
	 * recv_complete下降沿缓存cache_line_sdata数据到cache2_line_sdata并开始高电压时间计时
	 * last_line_data则保存上一次的输出数据
	 */
	reg [CHANNEL_NUM_MINUS_1:0] cache2_line_sdata;
	reg [CHANNEL_NUM_MINUS_1:0] last_line_sdata;
	always @(posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			enable_count_high_voltage_time <= 0;
			cache2_line_sdata <= ~0;
			last_line_sdata <= ~0;
		end
		else if (total_fault_flag) begin
			enable_count_high_voltage_time <= 0;
			cache2_line_sdata <= ~0;
			last_line_sdata <= ~0;
		end
		else if (recv_complete) begin
			enable_count_high_voltage_time <= 1;
			last_line_sdata <= cache2_line_sdata;
			cache2_line_sdata <= cache_line_sdata;
		end
		else begin
			enable_count_high_voltage_time <= 0;
		end
		
	end
	
	
	/**
	 * 对系统时钟做分频得到100Hz的脉冲信号，后续用于判断阀是否长时间开启
	 * 这样是不严谨的，应当以数据接收完成时刻开始计时，但CPLD资源不够了
	 */
	reg [17:0] sys_clk_divider;
	reg sys_clk_div;
	always @(posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			sys_clk_divider <= 0;
			sys_clk_div <= 0;
		end
		else if (total_fault_flag) begin
			sys_clk_divider <= 0;
			sys_clk_div <= 0;
		end
		else begin
			if (sys_clk_divider == 199_999) begin
				sys_clk_divider <= 0;
				sys_clk_div <= 1;
			end
			else begin
				sys_clk_divider <= sys_clk_divider + 1;
				sys_clk_div <= 0;
			end
		end
	end
	
	/*
	 * 在100Hz的脉冲信号时更新每路阀的开启时间计数器
	 * 到达超时时间后暂停计数
	 * 用100Hz的信号的原因是资源不够，必须减少计数器位宽
	 * 这导致计数器存在随机的单周期不稳定时间
	 */
	reg [7:0] longopen_counter [0:CHANNEL_NUM_MINUS_1];	
	integer k;
	always @(posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			for (k = 0; k < CHANNEL_NUM; k = k + 1) begin
				longopen_counter[k] <= 0;
			end
		end
		else if (total_fault_flag) begin
			for (k = 0; k < CHANNEL_NUM; k = k + 1) begin
				longopen_counter[k] <= 0;
			end
		end
		else begin
			for (k = 0; k < CHANNEL_NUM; k = k + 1) begin
				if (cache2_line_sdata[k] == 0) begin
					if (sys_clk_div && (longopen_counter[k] < LONGOPEN_COUNTER_THRESHOLD))
						longopen_counter[k] <= longopen_counter[k] + 7'd1;
					else
						longopen_counter[k] <= longopen_counter[k];
				end
				else begin
					longopen_counter[k] <= 0;
				end
			end
		end
	end

	/**
	 * 高电压时间内(is_high_voltage_time高电平时)，按cache2_line_sdata打开所需高电压；高电压时间后关闭
	 * 按cache2_line_sdata打开低电压
	 * 需要注意的是，已经开着的喷阀， 在高压时间内，不会再次使用高电压，只是保持低电压
	 * 此外，根据开启时间计数器是否超时来决定是否关闭某路阀
	 * total_fault_flag会关闭所有喷阀
	 */
	integer m;
	// 已经开着的喷阀，在高压时间内，不会再次使用高电压，只是保持低电压
	wire [CHANNEL_NUM_MINUS_1:0] signal_high_voltage_wire = ~last_line_sdata | cache2_line_sdata;
	always @ (posedge sys_clk or negedge rst_n) begin
		if (!rst_n) begin
			signal_low_voltage <= ~0;
			signal_high_voltage <= ~0;
		end
		else if (total_fault_flag) begin
			signal_low_voltage <= ~0;
			signal_high_voltage <= ~0;
		end
		else if (is_high_voltage_time) begin
			// 阀的开启时间不超过LONGOPEN_COUNTER_THRESHOLD
			for (m = 0; m < CHANNEL_NUM; m = m + 1) begin
				signal_high_voltage[m] <= signal_high_voltage_wire[m] | ~(longopen_counter[m] < LONGOPEN_COUNTER_THRESHOLD);
				signal_low_voltage[m] <= cache2_line_sdata[m] | ~(longopen_counter[m] < LONGOPEN_COUNTER_THRESHOLD);
			end
		end
		else begin
			signal_high_voltage <= ~0;
			for (m = 0;m < CHANNEL_NUM; m = m + 1) begin
				signal_low_voltage[m] <= cache2_line_sdata[m] | ~(longopen_counter[m] < LONGOPEN_COUNTER_THRESHOLD);
			end
		end
	end
	
endmodule
      