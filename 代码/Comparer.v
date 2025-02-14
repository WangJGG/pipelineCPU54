`include "MIPS.vh"
`timescale 1ns / 1ps

module Comparer(
    input 			clk,
    input 			rst,
    input 	[31:0] 	a, 
    input 	[31:0] 	b,
    input 	[5:0] 	op,
    input 	[5:0] 	func,
    input 			exception,
    output reg 		branch 
    );
	
	always@(*) 
	begin
	    if(rst)
	        branch <= 1'b0;
		else if(op == `BEQ_op) 
			branch <= (a == b);
	    else if(op == `BNE_op) 
			branch <= (a != b);
		else if(op == `BGEZ_op) 
			branch <= (a >= 0);
	    else if(op == `J_op)
			branch <= 1'b1;
		else if(op == `JAL_op)
	        branch <= 1'b1;
	    else if(op == `JR_op && func == `JR_func)
            branch <= 1'b1;
        else if(op == `JALR_op && func == `JALR_func)
            branch <= 1'b1;
		else if(op == `TEQ_op && func == `TEQ_func)
			branch <= (a == b);
        else if(exception)
            branch <= 1'b1;
        else
            branch <= 1'b0;
	end
	
endmodule
