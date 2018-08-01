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

    output  [50:0] s;
    output  c_out;

    input   [50:0] a;
    input   [50:0] b;
    input   c_in;
   
    wire    [2:0] carries;
    wire    [2:0] sums;

    cla_tree24bit cla1(carries[0], s[23:0], a[23:0], b[23:0], c_in);
    cla_tree24bit cla2(carries[1], s[47:24], a[47:24], b[47:24], c_in);

endmodule
