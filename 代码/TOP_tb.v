`timescale 1ns / 1ps

module TOP_tb();
    reg clk, rst, ena;
    wire [7:0] o_seg, o_sel;

    initial 
    begin
        clk = 1'b0;
        rst = 1'b1;
        ena = 1'b1;
        #1 
        rst = 1'b0;
    end

    always 
    begin
        #1 
        clk = ~clk;
    end
    wire [31:0] pc      = TOP_tb.TOP_inst.CPU_inst.pc;
    wire [31:0] instr   = TOP_tb.TOP_inst.CPU_inst.instr;
    wire [31:0] reg0    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[0];
    wire [31:0] reg1    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[1];
    wire [31:0] reg2    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[2];   
    wire [31:0] reg3    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[3];
    wire [31:0] reg4    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[4];
    wire [31:0] reg5    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[5];
    wire [31:0] reg6    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[6];
    wire [31:0] reg7    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[7];
    wire [31:0] reg8    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[8];
    wire [31:0] reg9    = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[9];
    wire [31:0] reg10   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[10];
    wire [31:0] reg11   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[11];
    wire [31:0] reg12   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[12];
    wire [31:0] reg13   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[13];
    wire [31:0] reg14   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[14];
    wire [31:0] reg15   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[15];
    wire [31:0] reg16   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[16];
    wire [31:0] reg17   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[17];
    wire [31:0] reg18   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[18];
    wire [31:0] reg19   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[19];
    wire [31:0] reg20   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[20];
    wire [31:0] reg21   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[21];
    wire [31:0] reg22   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[22];
    wire [31:0] reg23   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[23];
    wire [31:0] reg24   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[24];
    wire [31:0] reg25   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[25];
    wire [31:0] reg26   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[26];
    wire [31:0] reg27   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[27];
    wire [31:0] reg28   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[28];
    wire [31:0] reg29   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[29];
    wire [31:0] reg30   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[30];
    wire [31:0] reg31   = TOP_tb.TOP_inst.CPU_inst.pipe_ID.Regfile_inst.array_reg[31];
    
    //中断不在此处仿真
    TOP TOP_inst(
        .clk(clk), 
        .rst(rst), 
        .ena(ena), 
        .sel(2'b00),
        .o_seg(o_seg), 
        .o_sel(o_sel)
    );

endmodule