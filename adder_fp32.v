`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:17:34 04/29/2018 
// Design Name: 
// Module Name:    adder_fp32 
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
module adder_fp32(clk, reset, rd, op, wr, z, x, y);

    input       clk;
    input       reset;
    
    input       rd;
    output      reg wr;

    input       op;
    reg         op_reg;
    wire        eop; // Effective operation after considering signs

    input       [31:0] x;
    input       [31:0] y;
    output      reg [31:0] z;

    reg         [31:0] a1, a2;
   
    wire        sig1;
    wire        sig2;
    reg         sig_out;

    wire        [7:0] exp1;
    wire        [7:0] exp2;
    reg         [7:0] exp_out;
    wire        [7:0] exp_diff;

    wire        [22:0] mant1;
    wire        [22:0] mant2;
    wire        [24:0] mant_sum;
    wire        [22:0] mant_out;
    reg         signed [26:0] sum_temp; // Sign bit, hidden bit, guard, and round

    wire        guard;
    wire        round;
    reg         sticky; 

    reg         [3:0] state;
    parameter   IDLE                = 4'd0,
                SPECIAL_CASES       = 4'd1,
                SWAP                = 4'd2,
                COMP                = 4'd3,
                ALIGN               = 4'd4,
                ADD                 = 4'd5,
                NORM_0              = 4'd6,
                NORM_1              = 4'd7,
                ROUND               = 4'd8, 
                PUT_Z               = 4'd10;

    // Special Values
    parameter   NAN                 = 32'b01111111111111111111111111111111,
                INF                 = 31'b1111111100000000000000000000000,
                ZERO                = 31'b0000000000000000000000000000000;

    assign      sig1 = a1[31];
    assign      sig2 = a2[31];

    assign      exp1 = a1[30:23]; 
    assign      exp2 = a2[30:23]; 
    assign      exp_diff = exp1 - exp2;

    assign      mant1 = a1[22:0];
    assign      mant2 = a2[22:0];
    assign      mant_out = sum_temp[24:2];

    cla_tree_24bit cla24(mant_sum[24], mant_sum[23:0], {1'b1, mant1}, sum_temp[25:2], 1'b0);

    assign      eop = (sig1 == sig2) ? op_reg : ~op_reg;

    assign      guard = sum_temp[1];
    assign      round = sum_temp[0];

    always @(posedge clk) begin

        if(reset) state <= IDLE;

        case(state)

            // Idle
            // Wait for input ack
            // assign inputs to registers to prevent them from changing
            IDLE : begin
                if(wr)begin
                    wr <= 1'b0;
                end else if(rd) begin
                    a1 <= x;
                    a2 <= y;
                    op_reg <= op;
                    state <= SPECIAL_CASES;
                end
            end

            // Special Cases
            // If a special case is detected (INF, NaN, 0)
            // we can determine output immediately
            SPECIAL_CASES : begin
                // If a1 or a2 is NaN, return NaN    
                if((exp1 == 255 && mant1 != 0) || (exp2 == 255 && mant2 != 0)) begin
                    {sig_out, exp_out, sum_temp[24:2]} <= NAN;
                    state <= PUT_Z;
                // If a1 = +/- inf and a2 = -a1, return NaN
                end else if((exp1 == 255) && (exp2 == 255)) begin
                    if(eop) begin
                        {sig_out, exp_out, sum_temp[24:2]} <= NAN;
                    end else begin
                        {sig_out, exp_out, sum_temp[24:2]} <= {sig1, INF};
                    end
                    state <= PUT_Z;
                // If a1 or a2 = +/- inf, return +/- inf
                end else if(exp1 == 255) begin
                    {sig_out, exp_out, sum_temp[24:2]} <= {sig1, INF};
                    state <= PUT_Z;
                end else if(exp2 == 255) begin
                    {sig_out, exp_out, sum_temp[24:2]} <= {(sig2 ^ op_reg), INF};
                    state <= PUT_Z;
                // If a1 is 0, return a2
                end else if(exp1 == 0 && mant1 == 0) begin
                    {sig_out, exp_out, sum_temp[24:2]} <= {sig2, exp2, mant2};
                    state <= PUT_Z;
                // If a2 is 0, return a1;
                end else if(exp2 == 0 && mant2 == 0) begin 
                    {sig_out, exp_out, sum_temp[24:2]} <= {sig1, exp1, mant1};
                    state <= PUT_Z;
                end else state <= SWAP;
            end

            // Swap
            // Ensure the smallest absolute vaule is in a2
            SWAP : begin
                if(exp1 == exp2 && mant2 > mant1) begin
                    a1 <= a2;
                    a2 <= a1;
                    exp_out <= exp2;
                    sig_out <= eop;
                end
                if(exp1 < exp2) begin
                    a1 <= a2;
                    a2 <= a1;
                    exp_out <= exp2;
                    sig_out <= eop;
                end else begin
                    exp_out <= exp1;
                    sig_out <= sig1;
                end
                state <= COMP;
            end

            // Complement
            // If the effective operation is subtraction, complement a2
            COMP : begin
                if(eop) sum_temp <= -{2'b01, mant2, 2'b0};
                else    sum_temp <= {2'b01, mant2, 2'b0};
                state <= ALIGN;
            end

            // Alignment
            // Align a1 and a2 so they can be added/subtracted
            ALIGN : begin
                if(exp_diff > 26) begin
                    sum_temp <= 26'b0;
                    sticky <= 1'b0;
                end else begin
                    sum_temp <= sum_temp >>> exp_diff;
                    sticky <= (sum_temp << 23 - exp_diff) | 1'b0;
                end
                state <= ADD;
            end

            // Add
            // Add a1 to the register containing a2, calc sticky bit
            ADD : begin
                sum_temp[26:2] <= mant_sum;
                if(~eop) state <= NORM_0;
                else state <= NORM_1;
            end
            
            // Normalize addition
            // If EOP is ADD, we need to shift at most 1 to the right
            // if there was a carry out
            NORM_0 : begin
                if(sum_temp[26]) begin
                    if(exp_out == 255) begin
                        sum_temp <= 28'b0;
                        state <= PUT_Z;
                    end else if(exp_out == 254) begin
                        exp_out <= 255;
                        sum_temp <= 28'b0;
                        state <= PUT_Z;
                    end else begin
                        sum_temp <= sum_temp >> 1;
                        exp_out <= exp_out + 1;
                        sticky <= sticky | round;
                    end
                end
                state <= ROUND;
            end 

            // Normalize subtraction
            // We may need to shift up to m times for SUB
            NORM_1 : begin
                if(sum_temp[25] || sum_temp == 28'b0 || exp_out == 0) begin
                    state <= ROUND; 
                end else begin
                    sum_temp <= sum_temp << 1;
                    exp_out <= exp_out - 1;
                end            
            end


            // Round
            // Round using guard, round, and sticky bit
            ROUND : begin
                sum_temp <= sum_temp + {((~sig_out) & (round | sticky)), 2'b0}; 
                state <= PUT_Z;
                if(sum_temp[26:2] == 24'hffffff) begin
                    if(exp_out == 8'hff) begin
                        sum_temp[25:2] <= 23'b0;
                    end else begin
                        exp_out <= exp_out + 1;
                    end
                end
            end
           
            // Put Out
            // Put output into the z register
            PUT_Z : begin
                z <= {sig_out, exp_out, mant_out};
                wr <= 1'b1;
                state <= IDLE;
            end

            default : state <= IDLE;

        endcase
    end

endmodule
