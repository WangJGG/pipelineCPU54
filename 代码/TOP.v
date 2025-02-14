`timescale 1ns / 1ps

module TOP(
    input           clk,
    input           rst,
    input           ena,
    input  [1:0]    sel,
    output [7:0]    o_seg,
    output [7:0]    o_sel
    );
    wire        clk_cpu;
    reg [19:0]  clk_divider;
    always@(posedge clk) 
    begin
        clk_divider = clk_divider + 1'b1;
    end
    assign clk_cpu = clk;               // �����ã����ڵ���
    //assign clk_cpu = clk_divider[19];       // �°���,��ƵƵ�ʣ�2^20*f ���ڹ۲�

    wire [31:0] data_show;
    wire [31:0] pc, instr;
    wire [31:0] register17, register18;
    /*CPU*/
    CPU CPU_inst(clk_cpu, rst, ena, pc, instr, register17,register18);
    /*7���������ʾ����*/
    MUX4_32 mux_display(register17, register18, pc, instr, sel, data_show);
    /*7�������*/
    seg7x16 seg7x16_inst(clk, rst, 1'b1, data_show, o_seg, o_sel);
endmodule
