`timescale 1ns / 1ps

module MEM(
    input           clk,
    input [31:0]    npc,
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

    input [31:0]    alu_data,
    input [31:0]    clz_data,
    input [31:0]    mul_hi,
    input [31:0]    mul_lo,
    input [31:0]    div_r,
    input [31:0]    div_q,

    input           modifier_sign,
    input           modifier_addr_sel,
    input [2:0]     modifier_sel,
    input [1:0]     dmem_wsel,
    input [1:0]     dmem_rsel,
    input           dmem_ena,
    input           dmem_wena,
    /*output*/
    output [31:0]   npc_out,
    output [31:0]   rs_data_out,
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

    output [31:0]   alu_data_out,
    output [31:0]   mul_hi_out,
    output [31:0]   mul_lo_out,
    output [31:0]   div_r_out,
    output [31:0]   div_q_out,
    output [31:0]   clz_data_out,
    output [31:0]   dmem_data_out
);

    wire [31:0] modifier;
	wire [31:0] dmem_data_temp;

    DMEM DMEM_inst(clk, dmem_ena, dmem_wena, dmem_wsel, dmem_rsel, dmem_data_out, alu_data, dmem_data_temp);
    assign modifier = modifier_addr_sel ? dmem_data_temp : rt_data;
    Modifier Modifier_inst(modifier, modifier_sel, modifier_sign, dmem_data_out);

    assign npc_out      = npc;
    assign rs_data_out  = rs_data;
    assign rd_sel_out   = rd_sel;
    assign rd_waddr_out = rd_waddr;
    assign rd_wena_out  = rd_wena;
    assign hi_data_out  = hi_data;
    assign lo_data_out  = lo_data;
    assign hi_wena_out  = hi_wena;
    assign lo_wena_out  = lo_wena;
    assign hi_sel_out   = hi_sel;
    assign lo_sel_out   = lo_sel;
    assign cp0_data_out = cp0_data;
    assign alu_data_out = alu_data;
    assign clz_data_out = clz_data;
    assign mul_hi_out   = mul_hi;
    assign mul_lo_out   = mul_lo;
    assign div_q_out    = div_q;
    assign div_r_out    = div_r;

endmodule