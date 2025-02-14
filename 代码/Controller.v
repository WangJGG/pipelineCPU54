`include "MIPS.vh"
`timescale 1ns / 1ps

module Controller (
    input           branch,
    input [31:0]    status,
    input [31:0]    instr,

    output [2:0]    pc_sel_out,
    output          immed_sign_out,
    output          ext5_sel_out,
    output          rs_rena_out,
    output          rt_rena_out,
    output [2:0]    rd_sel_out,
    output [4:0]    rdc_out,
    output          rd_wena_out,
    output          alu_a_sel_out,
    output [1:0]    alu_b_sel_out,
    output [3:0]    aluc_out,
    output          mul_ena_out,
    output          div_ena_out,
    output          clz_ena_out,
    output          mul_sign_out,
    output          div_sign_out,
    output          modifier_sign_out,
    output          modifier_addr_sel_out,
    output [2:0]    modifier_sel_out,
    output          dmem_ena_out,
    output          dmem_wena_out,
    output [1:0]    dmem_wsel_out,
    output [1:0]    dmem_rsel_out,
    output          eret_out,
    output [4:0]    cause_out,
    output          exception_out,
    output [4:0]    cp0_addr_out,
    output          mfc0_out,
    output          mtc0_out,
    output          hi_wena_out,
    output          lo_wena_out,
    output [1:0]    hi_sel_out,
    output [1:0]    lo_sel_out

    );

    wire [5:0] op   = instr[31:26];
    wire [5:0] func = instr[5:0];

    wire ADD        = (op == `ADD_op && func == `ADD_func);
    wire ADDU       = (op == `ADDU_op && func == `ADDU_func);
    wire AND        = (op == `AND_op && func == `AND_func);
    wire NOR        = (op == `NOR_op && func == `NOR_func);
    wire OR         = (op == `OR_op && func == `OR_func);
    wire SLL        = (op == `SLL_op && func == `SLL_func);
    wire SLT        = (op == `SLT_op && func == `SLT_func);
    wire SLLV       = (op == `SLLV_op && func == `SLLV_func);
    wire SLTU       = (op == `SLTU_op && func == `SLTU_func);
    wire SRA        = (op == `SRA_op && func == `SRA_func);
    wire SRL        = (op == `SRL_op && func == `SRL_func);
    wire SRLV       = (op == `SRLV_op && func == `SRLV_func);
    wire SRAV       = (op == `SRAV_op && func == `SRAV_func);
    wire SUBU       = (op == `SUBU_op && func == `SUBU_func);
    wire SUB        = (op == `SUB_op && func == `SUB_func);
    wire XOR        = (op == `XOR_op && func == `XOR_func);
    wire JR         = (op == `JR_op && func == `JR_func);
    wire ADDI       = (op == `ADDI_op);
    wire ADDIU      = (op == `ADDIU_op);
    wire ANDI       = (op == `ANDI_op);
    wire ORI        = (op == `ORI_op);
    wire LUI        = (op == `LUI_op);
    wire XORI       = (op == `XORI_op);
    wire SLTI       = (op == `SLTI_op);
    wire SLTIU      = (op == `SLTIU_op);
    wire LW         = (op == `LW_op);
    wire SW         = (op == `SW_op);
    wire BEQ        = (op == `BEQ_op);
    wire BNE        = (op == `BNE_op);
    wire J          = (op == `J_op);
    wire JAL        = (op == `JAL_op);
    wire CLZ        = (op == `CLZ_op && func == `CLZ_func);
    wire DIVU       = (op == `DIVU_op && func == `DIVU_func);
    wire DIV        = (op == `DIV_op && func == `DIV_func);
    wire MUL        = (op == `MUL_op && func == `MUL_func);
	wire MULTU      = (op == `MULTU_op && func == `MULTU_func);
    wire JALR       = (op == `JALR_op && func == `JALR_func);
    wire LB         = (op == `LB_op);
    wire LBU        = (op == `LBU_op);
    wire LH         = (op == `LH_op);
    wire LHU        = (op == `LHU_op);
    wire SB         = (op == `SB_op);
    wire SH         = (op == `SH_op);
    wire MFC0       = (instr[31:21] == 11'b01000000000 && instr[10:3] == 8'b0);
    wire MFHI       = (op == `MFHI_op && func == `MFHI_func);
    wire MFLO       = (op == `MFLO_op && func == `MFLO_func);
    wire MTC0       = (instr[31:21] == 11'b01000000100 && instr[10:3] == 8'b0);
	wire MTHI       = (op == `MTHI_op && func == `MTHI_func);
	wire MTLO       = (op == `MTLO_op && func == `MTLO_func);
    wire BGEZ       = (op == `BGEZ_op);
	wire SYSCALL    = (op == `SYSCALL_op && func == `SYSCALL_func);
    wire TEQ        = (op == `TEQ_op && func == `TEQ_func);
    wire ERET       = (op == `ERET_op && func == `ERET_func);
    wire BREAK      = (op == `BREAK_op && func == `BREAK_func);

    // immed expand
    assign ext5_sel_out     = SLLV | SRAV | SRLV;
    assign immed_sign_out   = ADDI | ADDIU | SLTIU | SLTI;

	// PC
    assign pc_sel_out[2] = (BEQ & branch) | (BNE & branch) | (BGEZ & branch) | ERET;
    assign pc_sel_out[1] = ~(J | JR | JAL | JALR | (BEQ & branch) | (BNE & branch) | (BGEZ & branch) | ERET);
    assign pc_sel_out[0] = ERET | exception_out | JR | JALR;

    // DMEM & modifier
    assign dmem_ena_out     = LW | LH | LB | LHU | LBU | SW | SH | SB;
    assign dmem_wena_out    = SW | SH | SB;
    assign dmem_wsel_out[1] = SH | SB;
    assign dmem_wsel_out[0] = SH | SB;
    assign dmem_rsel_out[1] = LH | LB | LHU | LBU;
    assign dmem_rsel_out[0] = LB | LBU |LW;     
    assign modifier_sign_out  = LH | LB;
    assign modifier_addr_sel_out  = ~(SB | SH | SW);
    assign modifier_sel_out[0]    = LH | LHU | SB;
    assign modifier_sel_out[1]    = LB | LBU | SB;
    assign modifier_sel_out[2]    = SH;

	// regfile
    assign rs_rena_out   = ADDI | ADDIU | ANDI | ORI | SLTIU | XORI | SLTI | ADDU | ADD | SUB | SUBU |
                           AND | BEQ | BNE | JR | LW | SW | XOR | NOR | OR | SLTU | SLT | SRLV | SRAV | SLLV |
                           CLZ | DIVU | JALR | LB | LBU | LHU | LH | SB | SH | MUL | MULTU | TEQ | DIV;
    assign rt_rena_out   = ADDU | ADD | SUB | SUBU | AND | XOR | NOR | OR | SLL | SLLV | SLTU | SRA | SRL |
                           SLT | SRLV | SRAV | BEQ | BNE | DIV | DIVU | SW | SB | SH | MUL | MULTU | MTC0 | TEQ ;
    assign rd_wena_out   = ADDI | ADDIU | ANDI | ORI | SLTIU | LUI | XORI | SLTI | ADD | SUB | ADDU | SUBU | 
                           AND | XOR | NOR | OR | SLL | SLLV | SLTU | SRA | SRL | SLT | SRLV | SRAV | LB | 
                           LBU | LH | LHU | LW | MFC0 | CLZ | JAL | JALR | MFHI | MFLO | MUL;
    assign rdc_out = (ADD | ADDU | SUB | SUBU | AND | OR | XOR | NOR | SLT | SLTU | SLL | SRL | SRA | SLLV | SRLV | SRAV | CLZ | JALR | MFHI | MFLO | MUL) ? 
                     instr[15:11] : (( ADDI | ADDIU | ANDI | ORI | XORI | LB | LBU | LH | LHU | LW | SLTI | SLTIU | LUI | MFC0) ? 
                    instr[20:16] : (JAL ? 5'd31 : 5'b0));
    assign rd_sel_out[0] = ~(BEQ | BNE | BGEZ | DIV | DIVU | MULTU | LB | LBU | LH | LHU | LW | SB | SH | SW |
                             J | MTC0 | MFHI | MFLO | MTHI | MTLO | CLZ | ERET | SYSCALL | TEQ | BREAK);
    assign rd_sel_out[1] = MUL | MFC0 | MTC0 | CLZ | MFHI;
    assign rd_sel_out[2] = ~(BEQ | BNE | BGEZ | DIV | DIVU | MULTU | SB | SH | SW | J | JR | JAL | JALR | 
                            MFC0 | MTC0 | MFLO | MTHI | MTLO | CLZ | ERET | SYSCALL | TEQ | BREAK);

	// HI,LO
    assign hi_wena_out   = MUL | MULTU | DIV | DIVU | MTHI;
    assign hi_sel_out[0] = MUL | MULTU;
    assign hi_sel_out[1] = MTHI;
    assign lo_wena_out   = MUL | MULTU | DIV | DIVU | MTLO; 
    assign lo_sel_out[0] = MUL | MULTU;
    assign lo_sel_out[1] = MTLO;

    // CP0
    assign mfc0_out  = MFC0;
    assign mtc0_out  = MTC0;
    assign cp0_addr_out     = instr[15:11];
    assign cause_out        = BREAK ? `BREAK : (SYSCALL ? `SYSCALL : (TEQ ? `TEQ : 5'bz));
    assign eret_out         = ERET; 
    assign exception_out    = status[0] && ((SYSCALL && status[1]) || (BREAK && status[2]) || (TEQ && status[3]));

    // alu
    assign aluc_out[3]      = LUI | SLT | SLTU | SLTI | SLTIU | SLLV | SRLV | SRAV | SLL | SRL | SRA ;
    assign aluc_out[2]      = AND | OR | NOR | XOR | SLLV | SRLV | SRAV | SLL | SRL | SRA | ANDI | ORI | XORI;
    assign aluc_out[1]      = ADD | SUB | NOR | XOR | SLT | SLTU | SLTI | SLTIU | SLL | SLLV | ADDI | XORI | BEQ | BNE | BGEZ | TEQ;
    assign aluc_out[0]      = SUB | SUBU | OR | NOR | SLT | SLTI | SLL | SRL | SLLV | SRLV | ORI | BEQ | BNE | BGEZ | TEQ;
    assign alu_a_sel_out    = ~(SRA | SRL | SLL | DIV | DIVU | MUL | MULTU | CLZ | J | JR | JAL | JALR | MFC0 | MTC0 | MFHI | MTHI | MFLO | MTLO | ERET | SYSCALL | BREAK);
    assign alu_b_sel_out[1] = BGEZ;
    assign alu_b_sel_out[0] = ADDI | ADDIU | ANDI | ORI | XORI | SLTI | SLTIU | LUI | LB | LH | LBU | LHU | LW | SB | SH | SW;

    // mul, div, clz
    assign mul_ena_out   = MUL | MULTU;
    assign mul_sign_out  = MUL;
    assign div_ena_out   = DIV | DIVU;
    assign div_sign_out  = DIV;
    assign clz_ena_out   = CLZ;

endmodule
