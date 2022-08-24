`timescale 1ns / 100ps
module tb_valveboard_firmware();
	reg sys_clk;
	reg rst_n;
	reg line_sclk;
	reg line_sen;
	reg line_sdata;
	
	wire [47:0]  signal_high_voltage;
	wire [47:0]  signal_low_voltage;

	valveboard_firmware inst_valveboard_firmware(
			.sys_clk (sys_clk),
			.rst_n (rst_n),
			.line_sclk (line_sclk),
			.line_sen (line_sen),
			.line_sdata (line_sdata),
			.signal_high_voltage (signal_high_voltage),
			.signal_low_voltage (signal_low_voltage)
		);
    reg [47:0] valve_data;
    initial begin
        sys_clk = 0;
        rst_n = 0;
		line_sclk = 0;
		line_sen = 0;
		line_sdata = 1;
		#500;
		rst_n = 1;
		#500;
		valve_data = 0;
		
    end
	
	integer idx;
	
	always #500000 begin
		valve_data = valve_data + 1;
		line_sen = 1;#50;
		for (idx = 0; idx < 48; idx = idx + 1) begin
			if (valve_data[idx] == 1) begin
				line_sdata = 0;#125;
				line_sclk = 1;#125;
				line_sdata = 1;#125;
				line_sclk = 0;#250;
			end
			else begin
				line_sclk = 1;#250;
				line_sclk = 0;#250;
			end
		end
		#50;
		line_sen = 0;
	end
	
	always #25 sys_clk = ~sys_clk;

	
endmodule