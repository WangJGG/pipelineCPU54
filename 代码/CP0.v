`include "MIPS.vh"
`timescale 1ns / 1ps

module CP0(
    input           clk,
    input           rst,
    input   [31:0]  pc,
    input   [4:0]   rdc,
    input   [31:0]  wdata,
    input           mfc0,
    input           mtc0,
    input           exception,
    input           eret,
    input   [4:0]   cause,
    output  [31:0]  rdata_out,
    output  [31:0]  status_out,
    output  [31:0]  eaddr_out
);

    reg [31:0] cp0_registers [31:0];
    integer i;

    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            for(i = 0; i < 32; i = i + 1)
                cp0_registers[i] <= 32'b0;
        end
        else if(mtc0)
        begin
            cp0_registers[rdc] <= wdata;
        end
        else if(exception)
        begin
            cp0_registers[`STATUS] <= { cp0_registers[`STATUS][26:0], 5'b0 };
            cp0_registers[`CAUSE]  <= { 25'd0, cause, 2'd0 };
            cp0_registers[`EPC]    <= pc;
        end
        else if(eret)
        begin
            cp0_registers[`STATUS] <= { 5'b0, cp0_registers[`STATUS][31:5] };
        end    
    end
   
    
    assign status_out  = cp0_registers[`STATUS];
    assign eaddr_out   = eret ? cp0_registers[`EPC] : 32'h00400004;  
    assign rdata_out   = mfc0 ? cp0_registers[rdc] : 32'bz;

endmodule
