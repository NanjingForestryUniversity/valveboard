`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/28 19:44:24
// Design Name: 
// Module Name: valve_board_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module valve_board_tb();

	reg sys_clk; 
	reg sys_rst_n; 

	wire sclk;
	wire sen;
	wire sdata;

initial begin
	sys_clk = 1'b0; 
	sys_rst_n = 1'b0;
	#200 
	sys_rst_n = 1'b1; 
end

always #2.5 sys_clk = ~sys_clk;
 
valve_test u_valve_test(
   .sys_clk_p(sys_clk),
   .sys_clk_n(~sys_clk),
   .rst_n(sys_rst_n),
   
   .sclk(sclk),  // AH17
   .sen(sen),  // AF17
   .sdata(sdata)  // AH16
    );
endmodule
