`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:51 03/24/2018 
// Design Name: 
// Module Name:    csa 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module csa(carry, sum, x, y, z);

    output  [50:0] sum;
    output  [50:0] carry;
    input   [50:0] x, y, z;

    assign carry[0] = 1'b0;

    full_adder last(,sum[50], x[50], y[50], z[50]);

    genvar i;
    generate
        for(i = 0; i < 50; i = i + 1)
        begin: CSA_gen
            full_adder FA(carry[i+1], sum[i], x[i], y[i], z[i]);
        end
    endgenerate


endmodule
