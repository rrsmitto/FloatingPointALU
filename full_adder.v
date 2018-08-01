`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:08:12 03/02/2018 
// Design Name: 
// Module Name:    full_adder 
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
module full_adder(c_out, sum, a, b, c_in);

    output sum, c_out;
    input a, b, c_in;

    wire w1, w2, w3, ab;

    xor(w1, a, b);
    xor(sum, c_in, w1);

    and(ab, a, b);
    and(w3, c_in, w1);
    or(c_out, ab, w3);

endmodule
