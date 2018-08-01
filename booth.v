`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:07 03/08/2018 
// Design Name: 
// Module Name:    booth 
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
module booth(p, x, y);
    
    output  [47:0] p;
    input   [24:0] x, y;

    wire    [26:0] X;

    wire    [2:0] A [12:0];
    
    wire    [25:0] pp [12:0];
    wire    [50:0] pp_ext [12:0];

    wire    [50:0] c [10:0];
    wire    [50:0] s [10:0];

    assign X = {x[24], x, 1'b0};

    genvar i;
    generate 
        for(i = 0; i < 13; i = i + 1) begin : PP_gen
            assign A[i] = X[2*i+2:2*i];
            booth_recode br(pp[i], y, A[i]);
            assign pp_ext[i] = {{25{pp[i][25]}}, pp[i]} << (2 * i);
        end
    endgenerate
    
    generate
        for(i = 0; i < 4; i = i + 1) begin : CSA_0
            csa csa0(c[i], s[i], pp_ext[i*3+2], pp_ext[i*3+1], pp_ext[i*3]);
        end
    endgenerate

    csa csa10(c[4], s[4], s[1], c[0], s[0]);
    csa csa11(c[5], s[5], c[2], s[2], c[1]);
    csa csa20(c[6], s[6], pp_ext[12], c[3], s[3]);
    
    csa csa21(c[7], s[7], s[5], c[4], s[4]);
    csa csa30(c[8], s[8], c[6], s[6], c[5]);

    csa csa40(c[9], s[9], s[8], c[7], s[7]);

    csa csa50(c[10], s[10], c[8], c[9], s[9]);

    cla_tree_48bit cla(, p[47:0], c[10][47:0], s[10][47:0], 1'b0);

endmodule
