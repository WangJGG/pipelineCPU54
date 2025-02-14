`timescale 1ns / 1ps

module EX(
    input           rst,
    input [31:0]    npc,
    input [31:0]    immed,
    input [31:0]    shamt,

    input [31:0]    rs_data,
    input [31:0]    rt_data,
    input [2:0]     rd_sel,
    input [4:0]     rd_waddr,
    input           rd_wena,

    input [31:0]    hi_data,
    input [31:0]    lo_data,
    input           hi_wena,
    input           lo_wena,
    input [1:0]     hi_sel,
    input [1:0]     lo_sel,
    input [31:0]    cp0_data,

    input           alu_a_sel,
    input [1:0]     alu_b_sel,
    input [3:0]     aluc,
    input           clz_ena,
    input           mul_ena,
    input           div_ena,
    input           mul_sign,
    input           div_sign,

    input           modifier_sign,
    input           modifier_addr_sel,
    input [2:0]     modifier_sel,
    input           dmem_ena,
    input           dmem_wena,
    input [1:0]     dmem_wsel,
    input [1:0]     dmem_rsel,

    /*output*/
    output [31:0]   clz_data_out,
    output [31:0]   alu_data_out,
    output [31:0]   mul_hi_out,
    output [31:0]   mul_lo_out,
    output [31:0]   div_r_out,
    output [31:0]   div_q_out,
    /*instr & register*/
    output [31:0]   npc_out,
    output [31:0]   rs_data_out,
    output [31:0]   rt_data_out,
    output [2:0]    rd_sel_out,
    output [4:0]    rd_waddr_out,
    output          rd_wena_out,
    output [31:0]   hi_data_out,
    output [31:0]   lo_data_out,
    output          hi_wena_out,
    output          lo_wena_out,
    output [1:0]    hi_sel_out,
    output [1:0]    lo_sel_out,
    output [31:0]   cp0_data_out,
    /*MEM*/
    output          modifier_sign_out,
    output          modifier_addr_sel_out,
    output [2:0]    modifier_sel_out,
    output          dmem_ena_out,
    output          dmem_wena_out,
    output [1:0]    dmem_wsel_out,
    output [1:0]    dmem_rsel_out
);

    wire [31:0] ALU_a;
    wire [31:0] ALU_b;
    wire zero, carry, negative, overflow;
    /*compute*/
    assign ALU_a = alu_a_sel ? rs_data: shamt;
    MUX4_32 mux_ALU_b(rt_data, immed, 32'bz, 32'bz, alu_b_sel, ALU_b);
    ALU ALU_inst(ALU_a, ALU_b, aluc, alu_data_out, zero, carry, negative, overflow);
    CLZ CLZ_inst(rs_data, clz_ena, clz_data_out);
    MULT MULT_inst(rst, mul_ena, mul_sign, rs_data, rt_data, mul_hi_out, mul_lo_out);
    DIV DIV_inst(rst, div_ena, div_sign, rs_data, rt_data, div_q_out, div_r_out);

    /*transfer*/
    /*instr & register*/
    assign npc_out                = npc;
    assign rs_data_out            = rs_data;
    assign rt_data_out            = rt_data;
    assign rd_sel_out             = rd_sel;
    assign rd_waddr_out           = rd_waddr;
    assign rd_wena_out            = rd_wena;
    assign hi_data_out            = hi_data;
    assign lo_data_out            = lo_data;
    assign hi_wena_out            = hi_wena;
    assign lo_wena_out            = lo_wena;
    assign hi_sel_out             = hi_sel;
    assign lo_sel_out             = lo_sel;
    assign cp0_data_out           = cp0_data;
    /*MEM*/
    assign modifier_sign_out      = modifier_sign;
    assign modifier_addr_sel_out  = modifier_addr_sel;
    assign modifier_sel_out       = modifier_sel;
    assign dmem_ena_out           = dmem_ena;
    assign dmem_wena_out          = dmem_wena;
    assign dmem_rsel_out          = dmem_rsel;
    assign dmem_wsel_out          = dmem_wsel;

endmodule
