`timescale 1ns / 1ps

module MEM_WB_reg(
    input               clk,
    input               rst,
    input               ena,

    input [31:0]        npc,
    input [31:0]        rs_data,
    input [2:0]         rd_sel,
    input [4:0]         rd_waddr,
    input               rd_wena,

    input [31:0]        hi_data,
    input [31:0]        lo_data,
    input               hi_wena,
    input               lo_wena,
    input [1:0]         hi_sel,
    input [1:0]         lo_sel,
    input [31:0]        cp0_data,

    input [31:0]        alu_data,
    input [31:0]        clz_data,
    input [31:0]        mul_hi,
    input [31:0]        mul_lo,
    input [31:0]        div_r,
    input [31:0]        div_q,
    input [31:0]        dmem_data,
    /*output*/
    output reg [31:0]   npc_out,
    output reg [31:0]   rs_data_out,
    output reg [2:0]    rd_sel_out,
    output reg [4:0]    rd_waddr_out,
    output reg          rd_wena_out,

    output reg [31:0]   hi_data_out,
    output reg [31:0]   lo_data_out,
    output reg          hi_wena_out,
    output reg          lo_wena_out,
    output reg [1:0]    hi_sel_out,
    output reg [1:0]    lo_sel_out,
    output reg [31:0]   cp0_data_out,

    output reg [31:0]   alu_data_out,
    output reg [31:0]   clz_data_out,
    output reg [31:0]   mul_hi_out,
    output reg [31:0]   mul_lo_out,
    output reg [31:0]   div_r_out,
    output reg [31:0]   div_q_out,
    output reg [31:0]   dmem_data_out

    );

    always @(posedge clk or posedge rst) 
    begin
        if(rst)
        begin
            npc_out         <= 32'b0;
            rs_data_out     <= 32'b0;
            rd_sel_out      <= 3'b0;
            rd_waddr_out    <= 5'b0;
            rd_wena_out     <= 1'b0;
            hi_data_out     <= 32'b0;
            lo_data_out     <= 32'b0;
            hi_wena_out     <= 1'b0;
            lo_wena_out     <= 1'b0;
            hi_sel_out      <= 2'b0;
            lo_sel_out      <= 2'b0;
            cp0_data_out    <= 32'b0;
            alu_data_out    <= 32'b0;
            clz_data_out    <= 32'b0;
            mul_hi_out      <= 32'b0;
            mul_lo_out      <= 32'b0;
            div_r_out       <= 32'b0;
            div_q_out       <= 32'b0;
            dmem_data_out   <= 32'b0;

        end
        else if(ena)
        begin
            npc_out         <= npc;		    
            rs_data_out     <= rs_data;
            rd_sel_out      <= rd_sel;
            rd_waddr_out    <= rd_waddr;
            rd_wena_out     <= rd_wena;
            hi_data_out     <= hi_data;
            lo_data_out     <= lo_data;
            hi_wena_out     <= hi_wena;
            lo_wena_out     <= lo_wena;
            hi_sel_out      <= hi_sel;
            lo_sel_out      <= lo_sel;
            cp0_data_out    <= cp0_data;
            alu_data_out    <= alu_data;
            clz_data_out    <= clz_data;
            mul_hi_out      <= mul_hi;
            mul_lo_out      <= mul_lo;
            div_r_out       <= div_r;
            div_q_out       <= div_q;
            dmem_data_out   <= dmem_data;
        end
    end 

endmodule
