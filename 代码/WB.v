`timescale 1ns / 1ps
module WB(
    input [31:0]    npc,
    input [31:0]    rs_data,
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
    input [31:0]    dmem_data,
    /*output*/
    output [31:0]   rd_data_out,
    output          rd_wena_out,
    output [4:0]    rd_waddr_out,

    output [31:0]   hi_data_out,
    output [31:0]   lo_data_out,
    output          hi_wena_out,
    output          lo_wena_out

    );
    /*remove mul and divide*/
    MUX4_32 mux_HI(div_r, mul_hi, rs_data, 32'hz, hi_sel, hi_data_out);
    MUX4_32 mux_LO(div_q, mul_lo, rs_data, 32'hz, lo_sel, lo_data_out);
    MUX8_32 mux_RD(lo_data, npc, clz_data, cp0_data, dmem_data, alu_data, hi_data, mul_lo, rd_sel, rd_data_out);

    /*transfer data*/
    assign hi_wena_out   = hi_wena;
    assign lo_wena_out   = lo_wena;
	assign rd_wena_out   = rd_wena;
	assign rd_waddr_out  = rd_waddr;

endmodule
