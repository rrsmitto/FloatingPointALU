`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:45:14 05/06/2018 
// Design Name: 
// Module Name:    cla_tree_24bit 
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
module cla_tree_24bit(c_out, s, a, b, c_in);

    output  [23:0] s;
    output  c_out;

    input   [23:0] a;
    input   [23:0] b;
    input   c_in;
    
    wire    [1:0] c;

    cla_tree cla1(c[0], s[7:0], a[7:0], b[7:0], c_in);
    cla_tree cla2(c[1], s[15:8], a[15:8], b[15:8], c[0]);
    cla_tree cla3(c_out, s[23:16], a[23:16], b[23:16], c[1]);

endmodule
