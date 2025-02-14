`timescale 1ns / 1ps
/*��Ϊ����ʵ��*/
module PC(
    input clk,          //�½�����Ч
    input rst,
    input ena,          //ʹ���ź�
    input stall,        //��ˮ��ͣ�ź�
    input [31:0] data_in,
    output reg [31:0] data_out
    );
    reg [31:0] pc_reg;
    initial begin
        data_out <= 32'h00400000;//�ϵ��ֵ
    end
    always@(posedge clk or posedge rst)
    begin
        if(rst) begin
            data_out <= 32'h00400000;//��ֵ����0
        end
        else begin
            if(ena & !stall)  
                data_out <= data_in;
            else 
                data_out <= data_out;
        end
    end
endmodule
