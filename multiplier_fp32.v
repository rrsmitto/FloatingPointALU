`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:53:16 04/27/2018 
// Design Name: 
// Module Name:    multiplier_fp32 
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
module multiplier_fp32(clk, reset, rd, wr, z, x, y);

    input   clk;
    input   reset;

    input   rd;
    output  reg wr;

    input   [31:0] x;
    input   [31:0] y;
    output  reg [31:0] z;

    reg     [31:0] a1, a2;

    wire    sig1;
    wire    sig2;
    reg     sig_out;

    wire    [7:0] exp1;
    wire    [7:0] exp2;
    reg     [7:0] exp_out;

    wire    [23:0] mant1;
    wire    [23:0] mant2;
    reg     [22:0] mant_out;

    wire    [47:0] m_temp;

    reg     guard;
    reg     round;
    reg     sticky; 

    assign  sig1 = a1[31];
    assign  sig2 = a2[31];

    assign  exp1 = a1[30:23];
    assign  exp2 = a2[30:23];

    assign  mant1 = {1'b1, a1[22:0]};
    assign  mant2 = {1'b1, a2[22:0]};

    booth bm(m_temp, {1'b0, mant1}, {1'b0, mant2});

    reg         [3:0] state;
    parameter   IDLE            = 4'd0,
                SPECIAL_CASES   = 4'd1,
                MULT            = 4'd2,
                ROUND           = 4'd3,
                PUT_Z           = 4'd4;

    // Special Values
    parameter   NAN                 = 32'b01111111111111111111111111111111,
                INF                 = 31'b1111111100000000000000000000000,
                ZERO                = 31'b0000000000000000000000000000000;


    always @(posedge clk) begin
        case(state)

            IDLE : begin
                if(wr) begin
                    wr <= 1'b0;
                end else if(rd) begin
                    a1 <= x;
                    a2 <= y;
                    state <= SPECIAL_CASES;
                end
            end

            SPECIAL_CASES : begin
                // If a1 or a2 is NaN, return NaN    
                if((exp1 == 255 && mant1[22:0] != 23'b0) || (exp2 == 255 && mant2[22:0] != 23'b0)) begin
                    {sig_out, exp_out, mant_out} <= NAN;
                    state <= PUT_Z;
                // If a1 or a2 are inf, return (sig1 * sig2) inf, unless the other is zero, return NaN
                end else if(a1[30:0] == INF || a2[30:0] == INF) begin
                    if(a1[30:0] == ZERO || a2[30:0] == ZERO) begin
                        {sig_out, exp_out, mant_out} <= NAN;
                    end else begin
                        {sig_out, exp_out, mant_out} <= {(sig1 ^ sig2), INF};
                    end
                    state <= PUT_Z;
                // If a1 or a2 is zero, return signed zero 
                end else if((a1[30:0] == ZERO) || (a2[30:0] == ZERO)) begin
                    {sig_out, exp_out, mant_out} <= {(sig1 ^ sig2), ZERO};
                    state <= PUT_Z;
                end else state <= MULT;
            end

            MULT: begin
                if(m_temp[47]) begin
                    mant_out <= m_temp[47:24];
                    exp_out <= exp1 + exp2 - 8'd127 + 1;
                    guard <= m_temp[23];
                    round <= m_temp[22];
                    sticky <= m_temp[21:0] | 0;
                end else begin
                    mant_out <= m_temp[46:23];
                    exp_out <= exp1 + exp2 - 8'd127;
                    guard <= m_temp[22];
                    round <= m_temp[21];
                    sticky <= m_temp[20:0] | 0;
                end
                sig_out <= sig1 ^ sig2;
                state <= ROUND;
            end

            ROUND : begin
                mant_out <= mant_out + ((~sig_out) & (round | sticky)); 
                state <= PUT_Z;
                if(mant_out == 24'hffffff) begin
                    if(exp_out == 8'd254) begin
                        mant_out <= 23'b0;
                        exp_out <= 8'd255;
                    end else begin
                        exp_out <= exp_out + 1;
                    end
                end                           
            end

            PUT_Z : begin
                z <= {sig_out, exp_out, mant_out};
                wr <= 1'b1;
                state <= IDLE;
            end

            default : state <= IDLE;
        endcase
    end

endmodule
