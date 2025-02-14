`timescale 1ns / 1ps
/*行为描述实现*/
module PC(
    input clk,          //下降沿有效
    input rst,
    input ena,          //使能信号
    input stall,        //流水暂停信号
    input [31:0] data_in,
    output reg [31:0] data_out
    );
    reg [31:0] pc_reg;
    initial begin
        data_out <= 32'h00400000;//上电初值
    end
    always@(posedge clk or posedge rst)
    begin
        if(rst) begin
            data_out <= 32'h00400000;//初值不是0
        end
        else begin
            if(ena & !stall)  
                data_out <= data_in;
            else 
                data_out <= data_out;
        end
    end
endmodule
