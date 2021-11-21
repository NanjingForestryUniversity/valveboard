`timescale 1ns / 1ns


module valve_test(
    input sys_clk_p,
    input sys_clk_n,
    input rst_n,
    
    output sclk,  // AH17
    output sen,  // AF17
    output sdata  // AH16
    );
    
    IBUFDS #(
    .DIFF_TERM("FALSE"),
    .IBUF_LOW_PWR("TRUE"),
    .IOSTANDARD("DEFAULT")
    ) IBUFDS_inst (
    .O(sys_clk),
    .I(sys_clk_p),
    .IB(sys_clk_n)
    );
    reg[47:0] input_data;
    reg valve_en;
    reg [64:0] cnt;
    
    
    valve_interface #(
    .CHANNELS (48),
    .FREQUENCY (1_000_000)
    )vi_instance (
    .input_data(input_data << 0),
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .valve_en(valve_en),
    .sclk(sclk),  // AH17
    .sen(sen),  // AF17
    .sdata(sdata)  // AH16
    );
    
    ila_0 your_instance_name (
	.clk(sys_clk), // input wire clk


	.probe0(sen), // input wire [0:0]  probe0  
	.probe1(sclk), // input wire [0:0]  probe1 
	.probe2(sdata), // input wire [0:0]  probe2		
	.probe3(valve_en) // input wire [0:0]  probe3
	
	
    );
    
    always @(posedge sys_clk or negedge rst_n) begin
        if(!rst_n)
            valve_en <= 0;
        else if (cnt == 96000 * 2) begin
            valve_en <= 1'd1;
        end
        else begin
            valve_en <= 1'd0;
        end
    end
    
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            input_data <= 48'b11;
        else if (cnt == 50_000_000)
            input_data <= {input_data[46:0], input_data[47]};
    end
    
    always @(posedge sys_clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 0;
        else if (cnt == 50_000_000)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
    
endmodule
