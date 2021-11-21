`timescale 1ns / 100ps
module tb_PF1();
	reg sys_clk;
	reg rst_n;
	reg line_sclk;
	reg line_sen;
	reg line_sdata;
	
	wire [48:0]  signal_high_voltage;
	wire [48:0]  signal_low_voltage;

	PF1 inst_PF1(
			.sys_clk (sys_clk),
			.rst_n (rst_n),
			.line_sclk (line_sclk),
			.line_sen (line_sen),
			.line_sdata (line_sdata),
			.signal_high_voltage (signal_high_voltage),
			.signal_low_voltage (signal_low_voltage)
		);

    initial begin
        sys_clk = 0;
        rst_n = 0;
		line_sclk = 0;
		line_sen = 0;
		line_sdata = 1;
		#500;
		rst_n = 1;
		#500;
		
    end
	
	integer idx;
	reg [47:0] valve_data;
	always #1000000 begin
		valve_data <= ~48'b1000_0000_0000_0000_0000_0000_0000_0001_0000_0000_0000_1001;
		line_sen = 1;#100;
		for (idx = 0; idx < 48; idx = idx + 1) begin
			if (valve_data[idx] == 0) begin
				line_sdata = 0;#250;
				line_sclk = 1;#250;
				line_sdata = 1;#250;
				line_sclk = 0;#500;
			end
			else begin
				line_sclk = 1;#500;
				line_sclk = 0;#500;
			end
		end
		#100;
		line_sen = 0;
	end
	
	always #25 sys_clk = ~sys_clk;

	
endmodule