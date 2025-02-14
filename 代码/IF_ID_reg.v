`timescale 1ns / 1ps

module IF_ID_reg(
    input               clk,
    input               rst,
    input               stall,
    input               branch,
    input [31:0]        npc_in,
    input [31:0]        instr_in,
    output reg [31:0]   npc_out,
    output reg [31:0]   instr_out 
    );

    always @(posedge clk or posedge rst) begin
		if(rst) 
        begin
		    npc_out   <= 32'b0;
		    instr_out <= 32'b0;       
		end 
        else if(branch)
        begin
            npc_out   <= 32'b0;
            instr_out <= 32'b0;
        end 
        else if(!stall) 
        begin
		    npc_out   <= npc_in;
		    instr_out <= instr_in;
		end
	end
	
endmodule
