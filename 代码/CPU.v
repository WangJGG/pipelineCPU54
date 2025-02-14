`timescale 1ns / 1ps

module CPU(
    input           clk,
    input           rst,
    input           ena,
    output [31:0]   pc,
    output [31:0]   instr,
    output [31:0]   reg17,
    output [31:0]   reg18
);


    //Áõ∏ÂÖ≥ÂíåÂàÜÊîØ‰ø°Âè?
    wire stall;
    wire branch;

    // IFÊÆµ‰ø°Âè?
    wire [31:0] IF_npc_out;


    // IDÊÆµ‰ø°Âè?
    /*input*/
    wire [31:0] ID_npc;
    wire [31:0] ID_instr;

    /*output*/
    /*instr*/
    wire [5:0]  ID_op_out;
    wire [5:0]  ID_func_out;
    wire [31:0] ID_immed_out;
    wire [31:0] ID_shamt_out;
    wire [31:0] ID_npc_out;
    wire [2:0]  ID_pc_sel_out;
    wire [31:0] ID_eaddr_out;
    wire [31:0] ID_baddr_out;
    wire [31:0] ID_jaddr_out;
    wire [31:0] ID_raddr_out;
    /*register*/
    wire [31:0] ID_rs_data_out;  
    wire [31:0] ID_rt_data_out;
    wire [2:0]  ID_rd_sel_out;
    wire [4:0]  ID_rd_waddr_out;
    wire        ID_rd_wena_out;
    wire [31:0] ID_hi_data_out;
    wire [31:0] ID_lo_data_out;
    wire        ID_hi_wena_out;
    wire        ID_lo_wena_out;
    wire [1:0]  ID_hi_sel_out;
    wire [1:0]  ID_lo_sel_out;
    wire [31:0] ID_cp0_data_out;
    /*EX*/
    wire        ID_alu_a_sel_out;
    wire [1:0]  ID_alu_b_sel_out;
    wire [3:0]  ID_aluc_out;
    wire        ID_clz_ena_out;
    wire        ID_mul_ena_out;
    wire        ID_div_ena_out;
    wire        ID_mul_sign_out;
    wire        ID_div_sign_out;
    /*MEM*/
    wire        ID_modifier_sign_out;
    wire        ID_modifier_addr_sel_out;
    wire [2:0]  ID_modifier_sel_out;
    wire        ID_dmem_ena_out;
    wire        ID_dmem_wena_out;
    wire [1:0]  ID_dmem_wsel_out;
    wire [1:0]  ID_dmem_rsel_out;


    // EXÊÆµ‰ø°Âè?
    /*input*/
    wire [5:0]  EX_op;
    wire [5:0]  EX_func;
    wire [31:0] EX_npc;
    wire [31:0] EX_immed;
    wire [31:0] EX_shamt;
    /*regfile*/
    wire [31:0] EX_rs_data;
    wire [31:0] EX_rt_data;
    wire [2:0]  EX_rd_sel;
    wire [4:0]  EX_rd_waddr;
    wire        EX_rd_wena;
    /*HI,LO,CP0*/
    wire [31:0] EX_hi_data;
    wire [31:0] EX_lo_data;
    wire        EX_hi_wena;
    wire        EX_lo_wena;
    wire [1:0]  EX_hi_sel;
    wire [1:0]  EX_lo_sel;
    wire [31:0] EX_cp0_data;
    /*EX Control*/
    wire        EX_alu_a_sel;
    wire [1:0]  EX_alu_b_sel;
    wire [3:0]  EX_aluc;
    wire        EX_clz_ena;
    wire        EX_mul_ena;
    wire        EX_div_ena;
    wire        EX_mul_sign;
    wire        EX_div_sign;
    /*MEM*/
    wire        EX_modifier_sign;
    wire        EX_modifier_addr_sel;
    wire [2:0]  EX_modifier_sel;
    wire        EX_dmem_ena;
    wire        EX_dmem_wena;
    wire [1:0]  EX_dmem_wsel;
    wire [1:0]  EX_dmem_rsel;
    
    /*output*/
    wire [31:0] EX_npc_out;
    wire [31:0] EX_rs_data_out;
    wire [31:0] EX_rt_data_out;
    wire [2:0]  EX_rd_sel_out;
    wire [4:0]  EX_rd_waddr_out;
    wire        EX_rd_wena_out;
    /*HI,LO,CP0*/
    wire [31:0] EX_hi_data_out;
    wire [31:0] EX_lo_data_out;
    wire        EX_hi_wena_out;
    wire        EX_lo_wena_out;
    wire [1:0]  EX_hi_sel_out;
    wire [1:0]  EX_lo_sel_out;
    wire [31:0] EX_cp0_data_out;
    /*EX result*/
    wire [31:0] EX_alu_data_out;
    wire [31:0] EX_clz_data_out;
    wire [31:0] EX_mul_hi_out;
    wire [31:0] EX_mul_lo_out;
    wire [31:0] EX_div_r_out;
    wire [31:0] EX_div_q_out;
    /*MEM*/
    wire        EX_modifier_sign_out;
    wire        EX_modifier_addr_sel_out;
    wire [2:0]  EX_modifier_sel_out;
    wire        EX_dmem_ena_out;
    wire        EX_dmem_wena_out;
    wire [1:0]  EX_dmem_wsel_out;
    wire [1:0]  EX_dmem_rsel_out;


    // MEMÊÆµ‰ø°Âè?
    /*input*/
    wire [31:0] MEM_npc;
    wire [31:0] MEM_rs_data;
    wire [31:0] MEM_rt_data;
    wire [2:0]  MEM_rd_sel;
    wire [4:0]  MEM_rd_waddr;
    wire        MEM_rd_wena;
    /*HI,LO,CP0*/
    wire [31:0] MEM_hi_data;
    wire [31:0] MEM_lo_data;
    wire        MEM_hi_wena;
    wire        MEM_lo_wena;
    wire [1:0]  MEM_hi_sel;
    wire [1:0]  MEM_lo_sel;
    wire [31:0] MEM_cp0_data;
    /*EX result*/
    wire [31:0] MEM_alu_data;
    wire [31:0] MEM_clz_data;
    wire [31:0] MEM_mul_hi;
    wire [31:0] MEM_mul_lo;  
    wire [31:0] MEM_div_r;
    wire [31:0] MEM_div_q;
    /*MEM*/
    wire        MEM_modifier_sign;
    wire        MEM_modifier_addr_sel;
    wire [2:0]  MEM_modifier_sel;
    wire        MEM_dmem_ena;
    wire        MEM_dmem_wena;
    wire [1:0]  MEM_dmem_wsel;
    wire [1:0]  MEM_dmem_rsel;

    /*output*/
    wire [31:0] MEM_npc_out;
    wire [31:0] MEM_rs_data_out;
    wire [2:0]  MEM_rd_sel_out;
    wire [4:0]  MEM_rd_waddr_out;
    wire        MEM_rd_wena_out;   
    /*HI,LO,CP0*/
    wire [31:0] MEM_hi_data_out;
    wire [31:0] MEM_lo_data_out;
    wire        MEM_hi_wena_out;
    wire        MEM_lo_wena_out;
    wire [1:0]  MEM_hi_sel_out;
    wire [1:0]  MEM_lo_sel_out;
    wire [31:0] MEM_cp0_data_out;
    /*EX result*/
    wire [31:0] MEM_alu_data_out;
    wire [31:0] MEM_clz_data_out;
    wire [31:0] MEM_mul_hi_out;
    wire [31:0] MEM_mul_lo_out;
    wire [31:0] MEM_div_r_out;
    wire [31:0] MEM_div_q_out;
    /*MEM result*/
    wire [31:0] MEM_dmem_data_out;


    // WBÊÆµ‰ø°Âè?
    /*input*/
    wire [31:0] WB_npc;
    wire [31:0] WB_rs_data;
    wire [2:0]  WB_rd_sel;
    wire [4:0]  WB_rd_waddr;
    wire        WB_rd_wena;
    /*HI,LO,CP0*/
    wire [31:0] WB_hi_data;
    wire [31:0] WB_lo_data;
    wire        WB_hi_wena;
    wire        WB_lo_wena;
    wire [1:0]  WB_hi_sel;
    wire [1:0]  WB_lo_sel;
    wire [31:0] WB_cp0_data;
    /*EX result*/
    wire [31:0] WB_alu_data;
    wire [31:0] WB_clz_data;
    wire [31:0] WB_mul_hi;
    wire [31:0] WB_mul_lo;
    wire [31:0] WB_div_r;
    wire [31:0] WB_div_q;
    /*MEM result*/
    wire [31:0] WB_dmem_data;

    /*output*/
    wire [31:0] WB_rd_data_out;
    wire        WB_rd_wena_out;
    wire [4:0]  WB_rd_waddr_out;
    wire [31:0] WB_hi_data_out;
    wire [31:0] WB_lo_data_out;
    wire        WB_hi_wena_out;
    wire        WB_lo_wena_out;



	// IFÊÆ?
    IF pipe_IF(
        .clk(clk),
        .rst(rst),
        .ena(ena),
        .stall(stall),
        .pc_sel(ID_pc_sel_out),
        .pc_eaddr(ID_eaddr_out),
        .pc_baddr(ID_baddr_out),
        .pc_raddr(ID_raddr_out),
        .pc_jaddr(ID_jaddr_out),
        .pc_out(pc),
        .npc_out(IF_npc_out),
        .instr_out(instr)
    );

    // IF/ID pipelineÂØÑÂ≠òÂô?
    IF_ID_reg pipe_IF_ID(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .branch(branch),
        .npc_in(IF_npc_out),
        .instr_in(instr),
        .npc_out(ID_npc),
        .instr_out(ID_instr)
    );

    // IDÊÆ?
    ID pipe_ID (
        .clk(clk),
        .rst(rst),
        .npc(ID_npc),
        .instr(ID_instr),
        .rd_data(WB_rd_data_out),
        .rd_wena(WB_rd_wena_out),
        .rd_waddr(WB_rd_waddr_out),
        .hi_data(WB_hi_data_out),
        .lo_data(WB_lo_data_out),
        .hi_wena(WB_hi_wena_out),
        .lo_wena(WB_lo_wena_out),
        /*EX Data*/
        .EX_op(EX_op),
        .EX_func(EX_func),
        .EX_npc(EX_npc_out),
        .EX_clz_data(EX_clz_data_out),
        .EX_alu_data(EX_alu_data_out),
        .EX_mul_hi(EX_mul_hi_out),
        .EX_mul_lo(EX_mul_lo_out),
        .EX_div_r(EX_div_r_out),
        .EX_div_q(EX_div_q_out),
        .EX_hi_data(EX_hi_data_out),
        .EX_lo_data(EX_lo_data_out),
        .EX_rs_data(EX_rs_data_out),
        /*EX Control*/
        .EX_rd_sel(EX_rd_sel_out),
        .EX_rd_waddr(EX_rd_waddr_out),
        .EX_rd_wena(EX_rd_wena_out),
        .EX_hi_wena(EX_hi_wena_out),
        .EX_lo_wena(EX_lo_wena_out),
        .EX_hi_sel(EX_hi_sel_out),
        .EX_lo_sel(EX_lo_sel_out),
        /*MEM Data*/
        .MEM_npc(MEM_npc_out),
        .MEM_alu_data(MEM_alu_data_out),
        .MEM_clz_data(MEM_clz_data_out),
        .MEM_mul_hi(MEM_mul_hi_out),
        .MEM_mul_lo(MEM_mul_lo_out),
        .MEM_div_q(MEM_div_r_out),
        .MEM_div_r(MEM_div_q_out),
        .MEM_dmem_data(MEM_dmem_data_out),
        .MEM_lo_data(MEM_lo_data_out),
        .MEM_hi_data(MEM_hi_data_out),
        .MEM_rs_data(MEM_rs_data_out),
        /*MEM Control*/
        .MEM_rd_wena(MEM_rd_wena_out),
        .MEM_rd_sel(MEM_rd_sel_out),
        .MEM_rd_waddr(MEM_rd_waddr_out),
        .MEM_hi_wena(MEM_hi_wena_out),
        .MEM_lo_wena(MEM_lo_wena_out),
        .MEM_hi_sel(MEM_hi_sel_out),
        .MEM_lo_sel(MEM_lo_sel_out),
        /*output*/
        .stall_out(stall),
        .branch_out(branch),
        .npc_out(ID_npc_out),
        .op_out(ID_op_out),
        .func_out(ID_func_out),
        .immed_out(ID_immed_out),
        .shamt_out(ID_shamt_out),
        /*PC*/
        .pc_sel_out(ID_pc_sel_out),
        .pc_eaddr_out(ID_eaddr_out),
        .pc_baddr_out(ID_baddr_out),
        .pc_jaddr_out(ID_jaddr_out),
        .pc_raddr_out(ID_raddr_out),
        /*regfile*/
        .rs_data_out(ID_rs_data_out),
        .rt_data_out(ID_rt_data_out),
        .rd_wena_out(ID_rd_wena_out),
        .rd_sel_out(ID_rd_sel_out),
        .rd_waddr_out(ID_rd_waddr_out),
        /*HI,LO,CP0*/
        .hi_data_out(ID_hi_data_out),
        .lo_data_out(ID_lo_data_out),
        .hi_wena_out(ID_hi_wena_out),
        .lo_wena_out(ID_lo_wena_out),
        .hi_sel_out(ID_hi_sel_out),
        .lo_sel_out(ID_lo_sel_out),
        .cp0_data_out(ID_cp0_data_out),
        /*EX*/
        .alu_a_sel_out(ID_alu_a_sel_out),
        .alu_b_sel_out(ID_alu_b_sel_out),
        .aluc_out(ID_aluc_out),
        .clz_ena_out(ID_clz_ena_out),
        .mul_ena_out(ID_mul_ena_out),
        .div_ena_out(ID_div_ena_out),
        .mul_sign_out(ID_mul_sign_out),
        .div_sign_out(ID_div_sign_out),
        /*MEM*/
        .modifier_sign_out(ID_modifier_sign_out),
        .modifier_addr_sel_out(ID_modifier_addr_sel_out),
        .modifier_sel_out(ID_modifier_sel_out),
        .dmem_ena_out(ID_dmem_ena_out),
        .dmem_wena_out(ID_dmem_wena_out),
        .dmem_wsel_out(ID_dmem_wsel_out),
        .dmem_rsel_out(ID_dmem_rsel_out),
        .reg17_out(reg17),
        .reg18_out(reg18)
    );

    // ID/EX pipelineÂØÑÂ≠òÂô?
    ID_EX_reg pipe_ID_EX(
        .clk(clk),
        .rst(rst),
        .ena(ena),
        .stall(stall),
        /*instr*/
        .op(ID_op_out),
        .func(ID_func_out),
        .npc(ID_npc_out),
        .immed(ID_immed_out),
        .shamt(ID_shamt_out),
        /*regfile*/
        .rs_data(ID_rs_data_out),
        .rt_data(ID_rt_data_out),
        .rd_sel(ID_rd_sel_out),
        .rd_waddr(ID_rd_waddr_out),
        .rd_wena(ID_rd_wena_out),
        /*HI,LO,CP0*/
        .hi_data(ID_hi_data_out),
        .lo_data(ID_lo_data_out),
        .hi_wena(ID_hi_wena_out),
        .lo_wena(ID_lo_wena_out),
        .hi_sel(ID_hi_sel_out),
        .lo_sel(ID_lo_sel_out),
        .cp0_data(ID_cp0_data_out),
        /*EX*/
        .alu_a_sel(ID_alu_a_sel_out),
        .alu_b_sel(ID_alu_b_sel_out),
        .aluc(ID_aluc_out),
        .clz_ena(ID_clz_ena_out),
        .mul_ena(ID_mul_ena_out),
        .div_ena(ID_div_ena_out),
        .mul_sign(ID_mul_sign_out),
        .div_sign(ID_div_sign_out),
        /*MEM*/
        .modifier_sign(ID_modifier_sign_out),
        .modifier_addr_sel(ID_modifier_addr_sel_out),
        .modifier_sel(ID_modifier_sel_out),
        .dmem_ena(ID_dmem_ena_out),
        .dmem_wena(ID_dmem_wena_out),
        .dmem_wsel(ID_dmem_wsel_out),
        .dmem_rsel(ID_dmem_rsel_out),
        /*output*/
        .op_out(EX_op),
        .func_out(EX_func),
        .npc_out(EX_npc),
        .immed_out(EX_immed),
        .shamt_out(EX_shamt),
        /*regfile*/
        .rs_data_out(EX_rs_data),
        .rt_data_out(EX_rt_data),
        .rd_sel_out(EX_rd_sel),
        .rd_waddr_out(EX_rd_waddr),
        .rd_wena_out(EX_rd_wena),
        /*HI,LO,CP0*/
        .hi_data_out(EX_hi_data),
        .lo_data_out(EX_lo_data),
        .hi_wena_out(EX_hi_wena),
        .lo_wena_out(EX_lo_wena),
        .hi_sel_out(EX_hi_sel),
        .lo_sel_out(EX_lo_sel),
        .cp0_data_out(EX_cp0_data),
        /*EX*/
        .alu_a_sel_out(EX_alu_a_sel),
        .alu_b_sel_out(EX_alu_b_sel),
        .aluc_out(EX_aluc),
        .clz_ena_out(EX_clz_ena),
        .mul_ena_out(EX_mul_ena),
        .div_ena_out(EX_div_ena),
        .mul_sign_out(EX_mul_sign),
        .div_sign_out(EX_div_sign),
        /*MEM*/
        .modifier_sign_out(EX_modifier_sign),
        .modifier_addr_sel_out(EX_modifier_addr_sel),
        .modifier_sel_out(EX_modifier_sel),
        .dmem_ena_out(EX_dmem_ena),
        .dmem_wena_out(EX_dmem_wena),
        .dmem_wsel_out(EX_dmem_wsel),
        .dmem_rsel_out(EX_dmem_rsel)
    );

    // EXÊÆ?
    EX pipe_EX(
        .rst(rst),
        .npc(EX_npc),
        .immed(EX_immed),
        .shamt(EX_shamt),
        /*regfile*/
        .rs_data(EX_rs_data),
        .rt_data(EX_rt_data),
        .rd_sel(EX_rd_sel),
        .rd_waddr(EX_rd_waddr),
        .rd_wena(EX_rd_wena),
        /*HI,LO,CP0*/
        .hi_data(EX_hi_data),
        .lo_data(EX_lo_data),
        .hi_wena(EX_hi_wena),
        .lo_wena(EX_lo_wena),
        .hi_sel(EX_hi_sel),
        .lo_sel(EX_lo_sel),
        .cp0_data(EX_cp0_data),
        /*EX Control*/
        .alu_a_sel(EX_alu_a_sel),
        .alu_b_sel(EX_alu_b_sel),
        .aluc(EX_aluc),
        .clz_ena(EX_clz_ena),
        .mul_ena(EX_mul_ena),
        .div_ena(EX_div_ena),
        .mul_sign(EX_mul_sign),
        .div_sign(EX_div_sign),
        /*MEM*/
        .modifier_sign(EX_modifier_sign),
        .modifier_addr_sel(EX_modifier_addr_sel),
        .modifier_sel(EX_modifier_sel),
        .dmem_ena(EX_dmem_ena),
        .dmem_wena(EX_dmem_wena),
        .dmem_wsel(EX_dmem_wsel),
        .dmem_rsel(EX_dmem_rsel),
        /*output*/
        .clz_data_out(EX_clz_data_out),
        .alu_data_out(EX_alu_data_out),
        .mul_hi_out(EX_mul_hi_out),
        .mul_lo_out(EX_mul_lo_out),
        .div_r_out(EX_div_r_out),
        .div_q_out(EX_div_q_out),
        /*npc & regfile*/
        .npc_out(EX_npc_out),
        .rs_data_out(EX_rs_data_out),
        .rt_data_out(EX_rt_data_out),
        .rd_sel_out(EX_rd_sel_out),
        .rd_waddr_out(EX_rd_waddr_out),
        .rd_wena_out(EX_rd_wena_out),
        /*HI,LO,CP0*/
        .hi_data_out(EX_hi_data_out),
        .lo_data_out(EX_lo_data_out),
        .hi_wena_out(EX_hi_wena_out),
        .lo_wena_out(EX_lo_wena_out),
        .hi_sel_out(EX_hi_sel_out),
        .lo_sel_out(EX_lo_sel_out),
        .cp0_data_out(EX_cp0_data_out),
        /*EX Control*/
        .modifier_sign_out(EX_modifier_sign_out),
        .modifier_addr_sel_out(EX_modifier_addr_sel_out),
        .modifier_sel_out(EX_modifier_sel_out),
        .dmem_ena_out(EX_dmem_ena_out),
        .dmem_wena_out(EX_dmem_wena_out),
        .dmem_wsel_out(EX_dmem_wsel_out),
        .dmem_rsel_out(EX_dmem_rsel_out)
    );

    // EX/MEM pipelineÂØÑÂ≠òÂô?
    EX_MEM_reg pipe_EX_MEM(
        .clk(clk),
        .rst(rst),
        .ena(ena),
        .npc(EX_npc_out),
        .rs_data(EX_rs_data_out),
        .rt_data(EX_rt_data_out),
        .rd_sel(EX_rd_sel_out),
        .rd_waddr(EX_rd_waddr_out),
        .rd_wena(EX_rd_wena_out),
        /*HI,LO,CP0*/
        .hi_data(EX_hi_data_out),
        .lo_data(EX_lo_data_out),
        .hi_wena(EX_hi_wena_out),
        .lo_wena(EX_lo_wena_out),
        .hi_sel(EX_hi_sel_out),
        .lo_sel(EX_lo_sel_out),
        .cp0_data(EX_cp0_data_out),
        /*EX result*/
        .alu_data(EX_alu_data_out),
        .clz_data(EX_clz_data_out),
        .mul_hi(EX_mul_hi_out),
        .mul_lo(EX_mul_lo_out),
        .div_r(EX_div_r_out),
        .div_q(EX_div_q_out),
        /*MEM*/
        .modifier_sign(EX_modifier_sign_out),
        .modifier_sel(EX_modifier_sel_out),
        .modifier_addr_sel(EX_modifier_addr_sel_out),
        .dmem_ena(EX_dmem_ena_out),
        .dmem_wena(EX_dmem_wena_out),
        .dmem_wsel(EX_dmem_wsel_out),
        .dmem_rsel(EX_dmem_rsel_out),
        /*output*/
        .npc_out(MEM_npc),
        .rs_data_out(MEM_rs_data),
        .rt_data_out(MEM_rt_data),
        .rd_sel_out(MEM_rd_sel),
        .rd_waddr_out(MEM_rd_waddr),
        .rd_wena_out(MEM_rd_wena),
        /*HI,LO,CP0*/
        .hi_data_out(MEM_hi_data),
        .lo_data_out(MEM_lo_data),
        .hi_wena_out(MEM_hi_wena),
        .lo_wena_out(MEM_lo_wena),
        .hi_sel_out(MEM_hi_sel),
        .lo_sel_out(MEM_lo_sel),
        .cp0_data_out(MEM_cp0_data),
        /*EX result*/
        .alu_data_out(MEM_alu_data),
        .clz_data_out(MEM_clz_data),
        .mul_hi_out(MEM_mul_hi),
        .mul_lo_out(MEM_mul_lo),
        .div_r_out(MEM_div_r),
        .div_q_out(MEM_div_q),
        /*MEM*/
        .modifier_sign_out(MEM_modifier_sign),
        .modifier_addr_sel_out(MEM_modifier_addr_sel),
        .modifier_sel_out(MEM_modifier_sel),
        .dmem_ena_out(MEM_dmem_ena),
        .dmem_wena_out(MEM_dmem_wena),
        .dmem_wsel_out(MEM_dmem_wsel),
        .dmem_rsel_out(MEM_dmem_rsel)
    );

    // MEMÊÆ?
    MEM pipe_MEM(
        .clk(clk),
        .npc(MEM_npc),
        .rs_data(MEM_rs_data),
        .rt_data(MEM_rt_data),
        .rd_sel(MEM_rd_sel),
        .rd_waddr(MEM_rd_waddr),
        .rd_wena(MEM_rd_wena),
        /*HI,LO,CP0*/
        .hi_data(MEM_hi_data),
        .lo_data(MEM_lo_data),
        .hi_wena(MEM_hi_wena),
        .lo_wena(MEM_lo_wena),
        .hi_sel(MEM_hi_sel),
        .lo_sel(MEM_lo_sel),
        .cp0_data(MEM_cp0_data),
        /*EX result*/
        .alu_data(MEM_alu_data),
        .clz_data(MEM_clz_data),
        .mul_hi(MEM_mul_hi),
        .mul_lo(MEM_mul_lo),
        .div_r(MEM_div_r),
        .div_q(MEM_div_q),
        /*MEM*/
        .modifier_sign(MEM_modifier_sign),
        .modifier_addr_sel(MEM_modifier_addr_sel),
        .modifier_sel(MEM_modifier_sel),
        .dmem_wsel(MEM_dmem_wsel),
        .dmem_rsel(MEM_dmem_rsel),
        .dmem_ena(MEM_dmem_ena),
        .dmem_wena(MEM_dmem_wena),
        /*output*/
        .npc_out(MEM_npc_out),
        .rs_data_out(MEM_rs_data_out),
        .rd_sel_out(MEM_rd_sel_out),
        .rd_waddr_out(MEM_rd_waddr_out),
        .rd_wena_out(MEM_rd_wena_out),
        /*HI,LO,CP0*/
        .hi_data_out(MEM_hi_data_out),
        .lo_data_out(MEM_lo_data_out),
        .hi_wena_out(MEM_hi_wena_out),
        .lo_wena_out(MEM_lo_wena_out),
        .hi_sel_out(MEM_hi_sel_out),
        .lo_sel_out(MEM_lo_sel_out),
        .cp0_data_out(MEM_cp0_data_out),
        /*EX result*/
        .alu_data_out(MEM_alu_data_out),
        .mul_hi_out(MEM_mul_hi_out),
        .mul_lo_out(MEM_mul_lo_out),
        .div_r_out(MEM_div_r_out),
        .div_q_out(MEM_div_q_out),
        .clz_data_out(MEM_clz_data_out),
        /*MEM result*/
        .dmem_data_out(MEM_dmem_data_out)
    );

    // MEM/WB pipelineÂØÑÂ≠òÂô?
    MEM_WB_reg pipe_MEM_WB(
        .clk(clk),
        .rst(rst),
        .ena(ena),
        .npc(MEM_npc_out),
        .rs_data(MEM_rs_data_out),
        .rd_sel(MEM_rd_sel_out),
        .rd_waddr(MEM_rd_waddr_out),
        .rd_wena(MEM_rd_wena_out),
        /*HI,LO,CP0*/
        .hi_data(MEM_hi_data_out),
        .lo_data(MEM_lo_data_out),
        .hi_wena(MEM_hi_wena_out),
        .lo_wena(MEM_lo_wena_out),
        .hi_sel(MEM_hi_sel_out),
        .lo_sel(MEM_lo_sel_out),
        .cp0_data(MEM_cp0_data_out),
        /*EX result*/
        .alu_data(MEM_alu_data_out),
        .clz_data(MEM_clz_data_out),
        .mul_hi(MEM_mul_hi_out),
        .mul_lo(MEM_mul_lo_out),
        .div_r(MEM_div_r_out),
        .div_q(MEM_div_q_out),
        /*MEM*/
        .dmem_data(MEM_dmem_data_out),
        /*output*/
        .npc_out(WB_npc),
        .rs_data_out(WB_rs_data),
        .rd_sel_out(WB_rd_sel),
        .rd_waddr_out(WB_rd_waddr),
        .rd_wena_out(WB_rd_wena),
        /*HI,LO,CP0*/
        .hi_data_out(WB_hi_data),
        .lo_data_out(WB_lo_data),
        .hi_wena_out(WB_hi_wena),
        .lo_wena_out(WB_lo_wena),
        .hi_sel_out(WB_hi_sel),
        .lo_sel_out(WB_lo_sel),
        .cp0_data_out(WB_cp0_data),
        /*EX result*/
        .alu_data_out(WB_alu_data),
        .clz_data_out(WB_clz_data),
        .mul_hi_out(WB_mul_hi),
        .mul_lo_out(WB_mul_lo),
        .div_r_out(WB_div_r),
        .div_q_out(WB_div_q),
        /*MEM result*/
        .dmem_data_out(WB_dmem_data)
    );

    // WBÊÆ?
    WB pipe_WB(
        .npc(WB_npc),
        .rs_data(WB_rs_data),
        .rd_sel(WB_rd_sel),
        .rd_waddr(WB_rd_waddr),
        .rd_wena(WB_rd_wena),
        /*HI,LO,CP0*/
        .hi_data(WB_hi_data),
        .lo_data(WB_lo_data),
        .hi_wena(WB_hi_wena),
        .lo_wena(WB_lo_wena),
        .hi_sel(WB_hi_sel),
        .lo_sel(WB_lo_sel),
        /*EX result*/
        .cp0_data(WB_cp0_data),
        .alu_data(WB_alu_data),
        .clz_data(WB_clz_data),
        .mul_hi(WB_mul_hi),
        .mul_lo(WB_mul_lo),
        .div_r(WB_div_r),
        .div_q(WB_div_q),
        /*MEM result*/
        .dmem_data(WB_dmem_data),
        /*output*/
        .rd_data_out(WB_rd_data_out),
        .rd_wena_out(WB_rd_wena_out),
        .rd_waddr_out(WB_rd_waddr_out),
        .hi_data_out(WB_hi_data_out),
        .lo_data_out(WB_lo_data_out),
        .hi_wena_out(WB_hi_wena_out),
        .lo_wena_out(WB_lo_wena_out)
    );

endmodule