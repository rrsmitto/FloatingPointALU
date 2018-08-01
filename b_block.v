`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:11 02/15/2018 
// Design Name: 
// Module Name:    b_block 
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
module b_block(c_out2, c_out1, g3, p3, g2, p2, g1, p1, c_in);

   output c_out1, c_out2, g3, p3;
   input  g2, p2, g1, p1, c_in;

   wire   w1, w2;

   and (p3, p2, p1);
  
   and (w1, p2, g1);
   or (g3, g2, w1);
   
   assign c_out1 = c_in;
   
   and(w2, p1, c_in);
   or (c_out2, g1, w2);

endmodule
