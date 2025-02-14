`timescale 1ns / 1ps

module MUX4_32(
    input   [31:0]      x0,
    input   [31:0]      x1,
    input   [31:0]      x2,
    input   [31:0]      x3,
    input   [1:0]       sel,
    output reg [31:0]   y
    );
	
    always@(*) begin
        case(sel)
            2'b00:      y <= x0;
            2'b01:      y <= x1;
            2'b10:      y <= x2;
            2'b11:      y <= x3;
        endcase
   end
endmodule
