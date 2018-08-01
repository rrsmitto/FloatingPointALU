`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:45 02/15/2018 
// Design Name: 
// Module Name:    a_block 
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
module a_block(sum, gen, prop, c_in, a, b);

   input a, b, c_in;
   output sum, gen, prop;
	wire w;

   or (prop, a, b);
   and (gen, a, b);
   xor (w, a, b);
	xor (sum, w, c_in);

endmodule
