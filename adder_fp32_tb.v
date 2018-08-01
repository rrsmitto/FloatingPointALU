`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:05:22 05/01/2018
// Design Name:   adder_fp32
// Module Name:   /media/ryan/FEB4E63EB4E5F8D3/Work/ENEE359F/Project/floating_point_processor/adder_32fp_tb.v
// Project Name:  floating_point_processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder_fp32
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module adder_fp32_tb;

    // Inputs
    reg [31:0] x;
    reg [31:0] y;
    reg op;
    reg clk;
    reg rd;
    reg reset;

    // Outputs
    wire [31:0] z;
    wire wr;

    // Instantiate the Unit Under Test (UUT)
    adder_fp32 uut (
        .clk(clk),
        .reset(reset),
        .op(op),
        .rd(rd),
        .wr(wr),
        .z(z), 
        .x(x), 
        .y(y) 
        );

    always #10 clk = ~clk;

    initial begin
        // Initialize Inputs
        x = 0;
        y = 0;
        op = 0;
        clk = 0;
        rd = 0;
        reset = 1;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        // 1 + 10 = 11
        reset = 0;
        rd = 1;
        x = 32'b00111111100000000000000000000000;
        y = 32'b01000001001000000000000000000000;
        #200 rd = 0;
			$display("%b + %b = %b", x, y, z, $time);
        
        // 1 - 1E10 = -1E10; no diff
        #200 rd = 1;
        op = 1;
        x = 32'b00111111100000000000000000000000;
        y = 32'b01010000000101010000001011111001;
        #200 rd = 0;
        			$display("%b - %b = %b", x, y, z, $time);

        // 1 + (-1E10) = (-1E10); no diff
        #200 rd = 1;
        op = 0;
        x = 32'b00111111100000000000000000000000;
        y = 32'b11010000000101010000001011111001;
        #200 rd = 0;
    			$display("%b + %b = %b", x, y, z, $time);

        // 1 + NaN = NaN
        #200 rd = 1;
        op = 0;
        x = 32'b00111111100000000000000000000000;
        y = 32'b01111111111111111011111111000000;
        #200 rd = 0;
 			$display("%b + %b = %b", x, y, z, $time);

        // NaN + 1 = NaN
        #200 rd = 1;
        op = 0;
        x = 32'b01111111111111111011111111000000;
        y = 32'b00111111100000000000000000000000;
        #200 rd = 0;
			$display("%b + %b = %b", x, y, z, $time);

        // Inf + (-Inf) = NaN
        #200 rd = 1;
        op = 0;
        x = 32'b01111111100000000000000000000000;
        y = 32'b11111111100000000000000000000000;
        #200 rd = 0;
			$display("%b + %b = %b", x, y, z, $time);

        // -Inf - (-Inf) == NaN
        #200 rd = 1;
        op = 1;
        x = 32'b11111111100000000000000000000000;
        y = 32'b11111111100000000000000000000000;
        #200 rd = 0;
			$display("%b - %b = %b", x, y, z, $time);

        // -Inf + 10 == -Inf 
        #200 rd = 1;
        op = 0;
        x = 32'b11111111100000000000000000000000;
        y = 32'b01000001001000000000000000000000;
        #200 rd = 0;
			$display("%b + %b = %b", x, y, z, $time);

        // -Inf - (+Inf) == Inf 
        #200 rd = 1;
        op = 1;
        x = 32'b01111111100000000000000000000000;
        y = 32'b11111111100000000000000000000000;
        #200 rd = 0;
			$display("%b - %b = %b", x, y, z, $time);

        // 10 + (-Inf) == -Inf 
        #200 rd = 1;
        op = 0;
        x = 32'b01000001001000000000000000000000;
        y = 32'b11111111100000000000000000000000;
        #200 rd = 0;
			$display("%b + %b = %b", x, y, z, $time);

        // Addition of denormals 
        #200 rd = 1;
        op = 0;
        x = 32'b00000000001010000100000100000000;
        y = 32'b00000000000100000100000100000001;
        #200 rd = 0;
			$display("%b + %b = %b", x, y, z, $time);


        // Subtraction of denormals 
        #200 rd = 1;
        op = 1;
        x = 32'b00000000001110000100000100000001;
        y = 32'b00000000000100000100000100000001;
        #200 rd = 0;
			$display("%b - %b = %b", x, y, z, $time);

    end

endmodule

