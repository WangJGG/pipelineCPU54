`timescale 1ns / 1ps
module IMEM(
    input [9:0] addr_in,    //��ַ
    output [31:0] data_out   //ָ������
    ); 

dist_mem_gen_0 imem(    //ʵ����IP��
    .a(addr_in),    
    .spo(data_out)
    );
    
endmodule