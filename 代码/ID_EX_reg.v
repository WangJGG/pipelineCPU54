`timescale 1ns / 1ps

module ID_EX_reg(
    input               clk,
    input               rst,
    input               ena,
    input               stall,
    input [5:0]         op,
    input [5:0]         func,
    input [31:0]        npc,
    input [31:0]        immed,
    input [31:0]        shamt,
    input [31:0]        rs_data,
    input [31:0]        rt_data,
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

    input               alu_a_sel,
    input [1:0]         alu_b_sel,
    input [3:0]         aluc,
    input               clz_ena,
    input               mul_ena,
    input               div_ena,
    input               mul_sign,
    input               div_sign,

    input               modifier_sign,
    input               modifier_addr_sel,
    input [2:0]         modifier_sel,
    input               dmem_ena,
    input               dmem_wena,
    input [1:0]         dmem_wsel,
    input [1:0]         dmem_rsel,



    /*output*/
    /*instr*/
    output reg [5:0]    op_out,
    output reg [5:0]    func_out,
    output reg [31:0]   npc_out,
    output reg [31:0]   immed_out,
    output reg [31:0]   shamt_out,
    /*register*/
    output reg [31:0]   rs_data_out,
    output reg [31:0]   rt_data_out,
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
    /*EX*/
    output reg          alu_a_sel_out,
    output reg [1:0]    alu_b_sel_out,
    output reg [3:0]    aluc_out,
    output reg          clz_ena_out,
    output reg          mul_ena_out,
    output reg          div_ena_out,
    output reg          mul_sign_out,
    output reg          div_sign_out,
    /*MEM*/
    output reg          modifier_sign_out,
    output reg          modifier_addr_sel_out,
    output reg [2:0]    modifier_sel_out,
    output reg          dmem_ena_out,
    output reg          dmem_wena_out,
    output reg [1:0]    dmem_wsel_out,
    output reg [1:0]    dmem_rsel_out
    );

    always @(posedge clk or posedge rst) 
    begin
        if(rst || stall) 
        begin
            op_out              <= 6'b0;
            func_out            <= 6'b0;
            immed_out           <= 32'b0;
            shamt_out           <= 32'b0;
            npc_out             <= 32'b0;

            rs_data_out         <= 32'b0;
            rt_data_out         <= 32'b0;
            rd_sel_out          <= 3'b0;
            rd_waddr_out        <= 5'b0;
            rd_wena_out         <= 1'b0;
            hi_data_out         <= 32'b0;
            lo_data_out         <= 32'b0;
            hi_wena_out         <= 1'b0;
            lo_wena_out         <= 1'b0;
            hi_sel_out          <= 2'b0;
            lo_sel_out          <= 2'b0;
            cp0_data_out        <= 32'b0;

            alu_a_sel_out       <= 1'b0;
            alu_b_sel_out       <= 1'b0;
            aluc_out            <= 4'b0;
            clz_ena_out         <= 1'b0;
            mul_ena_out         <= 1'b0;
            div_ena_out         <= 1'b0;
            mul_sign_out        <= 1'b0;
            div_sign_out        <= 1'b0;

            modifier_sign_out     <= 1'b0;
            modifier_addr_sel_out <= 1'b0;
            modifier_sel_out      <= 3'b0;
            dmem_ena_out        <= 1'b0;
            dmem_wena_out       <= 1'b0;
            dmem_wsel_out       <= 2'b0;
            dmem_rsel_out       <= 2'b0;
        end
        else if(ena) 
        begin
            op_out              <= op;
            func_out            <= func;
            immed_out           <= immed;
            shamt_out           <= shamt;
            npc_out             <= npc;

            rs_data_out         <= rs_data;
            rt_data_out         <= rt_data;
            rd_sel_out          <= rd_sel;
            rd_waddr_out        <= rd_waddr;
            rd_wena_out         <= rd_wena;
            hi_data_out         <= hi_data;
            lo_data_out         <= lo_data;
            hi_wena_out         <= hi_wena;
            lo_wena_out         <= lo_wena;
            hi_sel_out          <= hi_sel;
            lo_sel_out          <= lo_sel;
            cp0_data_out        <= cp0_data;

            alu_a_sel_out       <= alu_a_sel;
            alu_b_sel_out       <= alu_b_sel;
            aluc_out            <= aluc;
            mul_ena_out         <= mul_ena;
            div_ena_out         <= div_ena;
            clz_ena_out         <= clz_ena;
            mul_sign_out        <= mul_sign;
            div_sign_out        <= div_sign;

            modifier_sign_out     <= modifier_sign;
            modifier_addr_sel_out <= modifier_addr_sel;
            modifier_sel_out      <= modifier_sel;
            dmem_ena_out        <= dmem_ena;
            dmem_wena_out       <= dmem_wena;
            dmem_wsel_out       <= dmem_wsel;
            dmem_rsel_out       <= dmem_rsel;
        end
    end 
endmodule
