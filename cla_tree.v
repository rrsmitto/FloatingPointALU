`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:43 02/15/2018 
// Design Name: 
// Module Name:    cla_tree 
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
module cla_tree #(parameter N = 8) (c_out, s, a, b, c_in);

	output [7:0] s;
	output c_out;

	input [7:0]  a, b;
	input c_in;

	wire [7:0]   c0, g0, p0;
	wire [3:0]   c1, g1, p1;
	wire [1:0]   c2, g2, p2;
	wire         g7, p7;


	//A level
	genvar       i;
	generate
		for(i = 0; i < N; i = i + 1)
		begin: ABlocks
			a_block a(s[i], g0[i], p0[i], c0[i], a[i], b[i]);
		end
	endgenerate

	//First B level
	b_block b0(c0[1], c0[0], g1[0], p1[0], g0[1], p0[1], g0[0], p0[0], c1[0]);
	b_block b1(c0[3], c0[2], g1[1], p1[1], g0[3], p0[3], g0[2], p0[2], c1[1]);
	b_block b3(c0[5], c0[4], g1[2], p1[2], g0[5], p0[5], g0[4], p0[4], c1[2]);
	b_block b4(c0[7], c0[6], g1[3], p1[3], g0[7], p0[7], g0[6], p0[6], c1[3]);

	//Second B level
	b_block b5(c1[1], c1[0], g2[0], p2[0], g1[1], p1[1], g1[0], p1[0], c2[0]);
	b_block b6(c1[3], c1[2], g2[1], p2[1], g1[3], p1[3], g1[2], p1[2], c2[1]);

	//Final B level
	b_block b7(c2[1], c2[0], g7, p7, g2[1], p2[1], g2[0], p2[0], c_in);
	
	assign c_out = g0[7] | (p0[7] & c0[7]);

endmodule
