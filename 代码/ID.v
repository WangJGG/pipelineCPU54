`timescale 1ns / 1ps

module ID(
	input           clk,
    input           rst,
    input [31:0]    npc,
    input [31:0]    instr,
    input [31:0]    rd_data,
    input           rd_wena,
    input [4:0]     rd_waddr,
    input [31:0]    hi_data,
    input [31:0]    lo_data,
    input           hi_wena,
    input           lo_wena,


    /*EX Data*/
    input [5:0]     EX_op,
    input [5:0]     EX_func,
    input [31:0]    EX_npc,
    input [31:0]    EX_mul_hi,
    input [31:0]    EX_mul_lo,
    input [31:0]    EX_div_r,
    input [31:0]    EX_div_q,
    input [31:0]    EX_clz_data,
    input [31:0]    EX_alu_data,
    input [31:0]    EX_hi_data,
    input [31:0]    EX_lo_data,
    input [31:0]    EX_rs_data,
    /*EX Control*/
    input           EX_hi_wena,
    input           EX_lo_wena,
    input           EX_rd_wena,
    input [1:0]     EX_hi_sel,
    input [1:0]     EX_lo_sel,
    input [2:0]     EX_rd_sel,
    input [4:0]     EX_rd_waddr,
    /*MEM Data*/
    input [31:0]    MEM_npc,
    input [31:0]    MEM_alu_data,
    input [31:0]    MEM_mul_hi,
    input [31:0]    MEM_mul_lo,
    input [31:0]    MEM_div_q,
    input [31:0]    MEM_div_r,
    input [31:0]    MEM_clz_data,
    input [31:0]    MEM_dmem_data,
    input [31:0]    MEM_lo_data,
    input [31:0]    MEM_hi_data,
    input [31:0]    MEM_rs_data,
    /*MEM Control*/
    input           MEM_hi_wena,
    input           MEM_lo_wena,
    input           MEM_rd_wena,
    input [1:0]     MEM_hi_sel,
    input [1:0]     MEM_lo_sel,
    input [2:0]     MEM_rd_sel,
    input [4:0]     MEM_rd_waddr,

    /*Output*/
    /*instr*/
    output          stall_out,
    output          branch_out,
    output [31:0]   npc_out,
    output [5:0]    op_out,
    output [5:0]    func_out,
    output [31:0]   immed_out,
    output [31:0]   shamt_out,
    /*PC*/
    output [2:0]    pc_sel_out,
    output [31:0]   pc_eaddr_out,
    output [31:0]   pc_baddr_out,
    output [31:0]   pc_jaddr_out,
    output [31:0]   pc_raddr_out,
    /*Regfile & HI,LO & CP0*/
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
    /*EX part*/
    output          alu_a_sel_out,
    output [1:0]    alu_b_sel_out,
    output [3:0]    aluc_out,
    output          mul_ena_out,
    output          div_ena_out,
    output          clz_ena_out,
    output          mul_sign_out,
    output          div_sign_out,
    /*MEM part*/
    output          modifier_sign_out,
    output          modifier_addr_sel_out,
    output [2:0]    modifier_sel_out,
    output          dmem_ena_out,
    output          dmem_wena_out,
    output [1:0]    dmem_wsel_out,
    output [1:0]    dmem_rsel_out,
    /*result output*/
    output [31:0]   reg17_out,      //c[i]
    output [31:0]   reg18_out       //d[i]
    );

    wire [5:0] op   = instr[31:26];
    wire [5:0] func = instr[5:0];
    wire [4:0] rsc  = instr[25:21];
    wire [4:0] rtc  = instr[20:16];
    wire rs_rena;
    wire rt_rena;
    wire immed_sign;
    
    wire [31:0] EX_fw_hi_data;
    wire [31:0] EX_fw_lo_data;
    wire [31:0] EX_fw_rd_data;
    wire [31:0] MEM_fw_hi_data;
    wire [31:0] MEM_fw_lo_data;
    wire [31:0] MEM_fw_rd_data;
    wire [31:0] hi_fw_data;
    wire [31:0] lo_fw_data;
    wire [31:0] rs_fw_data;
    wire [31:0] rt_fw_data;

    wire        ext5_sel;
    wire [4:0]  ext5_data;
    
    wire forward;
    wire rs_correlation, rt_correlation;
    wire [31:0] hi_data_tmp;
    wire [31:0] lo_data_tmp;
    wire [31:0] rs_data_tmp;
    wire [31:0] rt_data_tmp;

    wire        mfc0;
    wire        mtc0;
    wire        eret;
    wire        cp0_exec;
    wire [4:0]  cp0_addr;
    wire [4:0]  cp0_cause;
    wire [31:0] cp0_status;

    assign immed_out    = { { 16{ immed_sign & instr[15] } }, instr[15:0] };
    assign shamt_out    = { 27'b0, ext5_data };

    assign pc_baddr_out = npc + { { { 14{ instr[15] } }, instr[15:0], 2'b00 } };
    assign pc_jaddr_out = { npc[31:28], instr[25:0], 2'b00 };
    assign pc_raddr_out = rs_data_out;

    assign rs_data_out  = (forward && rs_correlation) ? rs_fw_data : rs_data_tmp;
    assign rt_data_out  = (forward && rt_correlation) ? rt_fw_data : rt_data_tmp;
    assign hi_data_out  = forward ? hi_fw_data : hi_data_tmp;
    assign lo_data_out  = forward ? lo_fw_data : lo_data_tmp;

    assign npc_out      = npc;
    assign op_out       = op;
    assign func_out     = func;

    assign ext5_data=ext5_sel?rs_data_out[4:0]:instr[10:6];

    Register HI_inst(clk, rst, hi_wena, hi_data, hi_data_tmp);
    Register LO_inst(clk, rst, lo_wena, lo_data, lo_data_tmp);
    Regfile Regfile_inst(clk, rst, rd_wena, rsc, rtc, rs_rena, rt_rena, rd_waddr, rd_data, rs_data_tmp, rt_data_tmp, reg17_out,reg18_out);

    CP0 CP0_inst(clk, rst, npc - 32'd4, cp0_addr, rt_data_out, mfc0, mtc0, cp0_exec, eret, cp0_cause, cp0_data_out, cp0_status, pc_eaddr_out);

    MUX4_32 mux_EX_fw_hi(EX_div_r, EX_mul_hi, EX_rs_data, 32'hz, EX_hi_sel, EX_fw_hi_data);
    MUX4_32 mux_EX_fw_lo(EX_div_q, EX_mul_lo, EX_rs_data, 32'hz, EX_lo_sel, EX_fw_lo_data);
    MUX8_32 mux_EX_fw_rd(EX_lo_data, EX_npc, EX_clz_data, 32'hz, 32'hz, EX_alu_data, EX_hi_data, EX_mul_lo, EX_rd_sel, EX_fw_rd_data);

    MUX4_32 mux_MEM_fw_hi(MEM_div_q, MEM_mul_hi, MEM_rs_data, 32'hz, MEM_hi_sel, MEM_fw_hi_data);
    MUX4_32 mux_MEM_fw_lo(MEM_div_r, MEM_mul_lo, MEM_rs_data, 32'hz, MEM_lo_sel, MEM_fw_lo_data);
    MUX8_32 mux_MEM_fw_rd(MEM_lo_data, MEM_npc, MEM_clz_data, 32'hz, MEM_dmem_data, MEM_alu_data, MEM_hi_data, MEM_mul_lo , MEM_rd_sel, MEM_fw_rd_data);

    Forwarder Forwarder_inst(
        .clk(clk),
        .rst(rst),
        .op(op),
        .func(func),
        .rs_rena(rs_rena),
        .rt_rena(rt_rena),
        .rsc(rsc),
        .rtc(rtc),
        .EX_op(EX_op),
        .EX_func(EX_func),
        .EX_hi_data(EX_fw_hi_data),
        .EX_lo_data(EX_fw_lo_data),
        .EX_rd_data(EX_fw_rd_data),
        .EX_hi_wena(EX_hi_wena),
        .EX_lo_wena(EX_lo_wena),
        .EX_rd_wena(EX_rd_wena),
        .EX_rdc(EX_rd_waddr),
        .MEM_hi_data(MEM_fw_hi_data),
        .MEM_lo_data(MEM_fw_lo_data),
        .MEM_rd_data(MEM_fw_rd_data),
        .MEM_hi_wena(MEM_hi_wena),
        .MEM_lo_wena(MEM_lo_wena),
        .MEM_rd_wena(MEM_rd_wena),
        .MEM_rdc(MEM_rd_waddr),
        .stall_out(stall_out),
        .forward_out(forward),
        .rs_correlation_out(rs_correlation),
        .rt_correlation_out(rt_correlation),
        .rs_data_out(rs_fw_data),
        .rt_data_out(rt_fw_data),
        .hi_data_out(hi_fw_data),
        .lo_data_out(lo_fw_data)
        );
	
    Comparer Comparer_inst(clk, rst, rs_data_out, rt_data_out, op, func, cp0_exec, branch_out);

    Controller Controller_inst(
        .branch(branch_out),
        .status(cp0_status),
        .instr(instr),
        .pc_sel_out(pc_sel_out),
        .immed_sign_out(immed_sign),
        .ext5_sel_out(ext5_sel),
        .rs_rena_out(rs_rena),
        .rt_rena_out(rt_rena),
        .rd_sel_out(rd_sel_out),
        .rdc_out(rd_waddr_out),
        .rd_wena_out(rd_wena_out),
        .alu_a_sel_out(alu_a_sel_out),
        .alu_b_sel_out(alu_b_sel_out),
        .aluc_out(aluc_out),
        .mul_ena_out(mul_ena_out),
        .div_ena_out(div_ena_out),
        .clz_ena_out(clz_ena_out),
        .mul_sign_out(mul_sign_out),
        .div_sign_out(div_sign_out),
        .modifier_sign_out(modifier_sign_out),
        .modifier_addr_sel_out(modifier_addr_sel_out),
        .modifier_sel_out(modifier_sel_out),
        .dmem_ena_out(dmem_ena_out),
        .dmem_wena_out(dmem_wena_out),
        .dmem_wsel_out(dmem_wsel_out),
        .dmem_rsel_out(dmem_rsel_out),
        .eret_out(eret),
        .cause_out(cp0_cause),
        .exception_out(cp0_exec),
        .cp0_addr_out(cp0_addr),
        .mfc0_out(mfc0),
        .mtc0_out(mtc0),
        .hi_wena_out(hi_wena_out),
        .lo_wena_out(lo_wena_out),
        .hi_sel_out(hi_sel_out),
        .lo_sel_out(lo_sel_out)
        );

endmodule
