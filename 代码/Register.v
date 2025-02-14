`timescale 1ns / 1ps

module Register(
    input               clk, 
    input               rst, 
    input               wena, 
    input [31:0]        data_in, 
    output reg [31:0]   data_out 
    );
	
    always@(negedge clk or posedge rst)
    begin
        if(rst) 
            data_out <= 32'b0;
        else if(wena) 
            data_out <= data_in;
    end

endmodule