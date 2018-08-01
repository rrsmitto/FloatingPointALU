`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:25:04 05/10/2018 
// Design Name: 
// Module Name:    cla_tree50bit 
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
module cla_tree_48bit(c_out, s, a, b, c_in);

    output  [47:0] s;
    output  c_out;

    input   [47:0] a;
    input   [47:0] b;
    input   c_in;
   
    wire    carries;

    cla_tree_24bit cla1(carries, s[23:0], a[23:0], b[23:0], c_in);
    cla_tree_24bit cla2(c_out, s[47:24], a[47:24], b[47:24], carries);

endmodule
