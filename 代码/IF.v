`timescale 1ns / 1ps

module IF(
    input               clk,
    input               rst,
    input               ena,
    input               stall,
    input   [2:0]       pc_sel,
    input   [31:0]      pc_eaddr,
    input   [31:0]      pc_baddr,
    input   [31:0]      pc_raddr,
    input   [31:0]      pc_jaddr,
    output  [31:0]      pc_out,
    output  [31:0]      npc_out,
    output  [31:0]      instr_out
    );

    // Internal signals
    wire [31:0] pc_next;
    wire [31:0] pc;

    // Calculate NPC
    assign npc_out = pc + 32'd4;

    // Next PC logic using mux8_32
    MUX8_32 mux_npc(
        pc_jaddr, 
        pc_raddr, 
        npc_out, 
        32'h00400004, 
        pc_baddr, 
        pc_eaddr, 
        32'bz, 
        32'bz, 
        pc_sel, 
        pc_next
    );
    // Instantiate PC module
    PC pc_inst(
        .clk(clk),
        .rst(rst),
        .ena(ena),
        .stall(stall),
        .data_in(pc_next),
        .data_out(pc)
    );
    
    // Instantiate instruction memory
    IMEM imem_inst(pc[11:2], instr_out);

    // Assign output signals
    assign pc_out = pc;
endmodule
