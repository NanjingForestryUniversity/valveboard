
module valve_interface(
    input [CHANNELS-1:0] input_data,
    input sys_clk,
    input rst_n,
    input valve_en,
    output reg sclk,  // AH17
    output reg sen,  // AF17
    output reg sdata  // AH16
    );
    parameter CHANNELS = 48;  // the valve board has 48 channels
    parameter FREQUENCY = 1_000_000;  // frequency of sclk is 1MHz
    
    parameter CHANNELS_MINUS_1 = CHANNELS - 1;  // the valve board has 48 channels
    parameter AUTO_RELOAD = 200_000_000 / FREQUENCY - 1;
    parameter AUTO_RELOAD_DIVIDE_2 = 200_000_000 / FREQUENCY / 2 - 1;
	parameter AUTO_RELOAD_DIVIDE_4_X1 = 200_000_000 / FREQUENCY / 4 - 1;
	parameter AUTO_RELOAD_DIVIDE_4_X3 = 200_000_000 / FREQUENCY / 4 * 3 - 1;
    reg transmit_triggle;
	reg transmit_complete;
    reg [25:0] cnt;
    reg [$clog2(CHANNELS):0] input_data_index;
	
	always @ (*) begin
		transmit_complete = (input_data_index == CHANNELS && cnt == AUTO_RELOAD_DIVIDE_2);
	end

    always @(posedge sys_clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 0;
        else if (cnt < AUTO_RELOAD)
            cnt <= cnt + 26'd1;
        else
            cnt <= 26'd0;
    end
	
	always @(posedge sys_clk or negedge rst_n) begin
        if(!rst_n)
            sclk <= 1;
        else if (cnt == AUTO_RELOAD_DIVIDE_2)
            sclk <= 0;
        else if (cnt == AUTO_RELOAD)
            sclk <= 1;
    end
    
    always @ (posedge sys_clk or negedge rst_n) begin

        if(!rst_n) begin
            sdata <= 1'd1;
			input_data_index <= 0;
		end
        else if (cnt == AUTO_RELOAD_DIVIDE_4_X3 && sen == 1'd1) begin
            sdata <= ~input_data[input_data_index];
			input_data_index <= input_data_index + 1;
		end
		else if (transmit_complete) begin
			sdata <= 1'd1;
			input_data_index <= 0;
		end
    end
	
	reg [1:0] valve_en_flag;
	wire posedge_valve_en = valve_en_flag[0] & ~valve_en_flag[1];
	always @ (posedge sys_clk or negedge rst_n) begin
		if (!rst_n)
			valve_en_flag <= 2'd0;
		else
			valve_en_flag <= {valve_en_flag[0], valve_en};
	end

    always @ (posedge sys_clk or negedge rst_n) begin

        if(!rst_n)
            transmit_triggle <= 1'd0;
        else if (posedge_valve_en == 1'd1)
            transmit_triggle <= 1'd1;
        else if (transmit_triggle == 1'd1 && cnt == AUTO_RELOAD_DIVIDE_2)
            transmit_triggle <= 1'd0;
    end
    
    always @ (posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            sen <= 1'd0;
        else if (transmit_triggle == 1'd1 && cnt == AUTO_RELOAD_DIVIDE_2)
            sen <= 1'd1;
		else if (transmit_complete)
			sen <= 1'd0;
	end
    
endmodule
