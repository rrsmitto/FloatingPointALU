`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:49:56 05/07/2018
// Design Name:   booth
// Module Name:   /media/ryan/FEB4E63EB4E5F8D3/Work/ENEE359F/Project/floating_point_processor/booth_tb.v
// Project Name:  floating_point_processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: booth
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module booth_tb;

    // Inputs
    reg [24:0] x;
    reg [24:0] y;

    // Outputs
    wire [49:0] p;

    // Instantiate the Unit Under Test (UUT)
    booth uut (
        .p(p), 
        .x(x), 
        .y(y)
        );

    initial begin
        // Initialize Inputs
        x = 0;
        y = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        x = 25'd5;
        y = 25'd6;

        #20;
        x = 25'h777777;
        y = 25'b0101010111101;

        #20;
        x = 25'd19;
        y = 25'hff;

        #20;
        x = 25'd49;
        y = 25'hff00ff;

        #20;
        x = 24'b111101100000000000000000;
        y = 24'b111101100000000000000000;
        #20;
        $display("%b * %b = %b", x, y, p, $time);

        #20;
        x = 24'hffffff;
        y = 24'hffffff;
        #20;
        $display("%b * %b = %b", x, y, p, $time);

        #20;
        x = 24'd18;
        y = 24'd982;
        #20;
        $display("%b * %b = %b", x, y, p, $time);

        #20;
        x = 24'd194;
        y = 24'd0911;
        #20;
        $display("%b * %b = %b", x, y, p, $time);

        #20;
        x = -25'b1;
        y = -25'b1;
        #20;
        $display("%b * %b = %b", x, y, p, $time);

        #20;
        x = -25'b1;
        y = 25'b1;
        #20;
        $display("%b * %b = %b", x, y, p, $time);




    end

endmodule

