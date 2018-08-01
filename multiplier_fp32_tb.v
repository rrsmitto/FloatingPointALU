`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:25:35 04/27/2018
// Design Name:   multiplier_fp32
// Module Name:   /media/ryan/FEB4E63EB4E5F8D3/Work/ENEE359F/Project/floating_point_processor/multiplier_fp32_tb.v
// Project Name:  floating_point_processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: multiplier_fp32
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module multiplier_fp32_tb;

    // Inputs
    reg [31:0] x;
    reg [31:0] y;
    reg clk;
    reg reset;
    reg rd;

    // Outputs
    wire [31:0] z;
    wire wr;

    // Instantiate the Unit Under Test (UUT)
    multiplier_fp32 uut (
        .clk(clk),
        .reset(reset),
        .rd(rd),
        .wr(wr),
        .z(z), 
        .x(x), 
        .y(y)
        );

    reg [31:0] correct;

    always #10 clk = ~clk;

    initial begin
        $display("%b * %b = %b", x, y, z, $time);
        // Initialize Inputs
        x = 0;
        y = 0;
        rd = 0;
        reset = 1;
        clk = 0;

        // Wait 100 ns for global reset to finish
        #100;
        reset = 0;

        // Add stimulus here
        // 123 * 123 = 15129
        #200 rd = 1;
        x = 32'b01000010111101100000000000000000;
        y = 32'b01000010111101100000000000000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // -43 * 43 = -1849
        #200 rd = 1;
        x = 32'b11000010001011000000000000000000;
        y = 32'b01000010001011000000000000000000;
        correct = 0;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // 1 * 10 = 10
        #200 rd = 1;
        x = 32'b00111111100000000000000000000000;
        y = 32'b01000001001000000000000000000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);


        // 1 * 1E10 = 1E10; no diff
        #200 rd = 1;
        x = 32'b00111111100000000000000000000000;
        y = 32'b01010000000101010000001011111001;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // 1 * (-1E10) = (-1E10); no diff
        #200 rd = 1;
        x = 32'b00111111100000000000000000000000;
        y = 32'b11010000000101010000001011111001;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // Inf * 0 = NaN 
        #200 rd = 1;
        x = 32'b01111111100000000000000000000000;
        y = 32'b0;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        //  -0 * 10 = -0 
        #200 rd = 1;
        x = 32'b10000000000000000000000000000000;
        y = 32'b01000001001000000000000000000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        //  0 * 10 = 0 
        #200 rd = 1;
        x = 32'b00000000000000000000000000000000;
        y = 32'b01000001001000000000000000000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // 1 * NaN = NaN
        #200 rd = 1;
        x = 32'b00111111100000000000000000000000;
        y = 32'b01111111111111111011111111000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // NaN * 1 = NaN
        #200 rd = 1;
        x = 32'b01111111111111111011111111000000;
        y = 32'b00111111100000000000000000000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // Inf * (-Inf) = -Inf
        #200 rd = 1;
        x = 32'b01111111100000000000000000000000;
        y = 32'b11111111100000000000000000000000;
        #100 rd = 0;		
        $display("%b * %b = %b", x, y, z, $time);


        // -Inf * (-Inf) = Inf 
        #200 rd = 1;
        x = 32'b11111111100000000000000000000000;
        y = 32'b11111111100000000000000000000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // -Inf 0 10 == -Inf 
        #200 rd = 1;
        x = 32'b11111111100000000000000000000000;
        y = 32'b01000001001000000000000000000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // Inf * (-Inf) == -Inf 
        #200 rd = 1;
        x = 32'b01111111100000000000000000000000;
        y = 32'b11111111100000000000000000000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // 10 * (-Inf) == -Inf 
        #200 rd = 1;
        x = 32'b01000001001000000000000000000000;
        y = 32'b11111111100000000000000000000000;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

        // Multiplication of denormals 
        #200 rd = 1;
        x = 32'b00000000001010000100000100000000;
        y = 32'b00000000000100000100000100000001;
        #100 rd = 0;

        $display("%b * %b = %b", x, y, z, $time);

        // Multiplication of denormals 
        #200 rd = 1;
        x = 32'b00000000001110000100000100000001;
        y = 32'b00000000000100000100000100000001;
        #100 rd = 0;
        $display("%b * %b = %b", x, y, z, $time);

    end

endmodule

