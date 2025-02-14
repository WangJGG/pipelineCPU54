`timescale 1ns / 1ps

module Modifier(
    input [31:0] 		data,
    input [2:0] 		sel,
    input 				sign,
    output reg [31:0] 	data_out
    );
	
    always@(*) 
	begin
        case(sel)
            3'b010: 	data_out <= { { 24{ sign & data[7] } }, data[7:0] };
            3'b011: 	data_out <= { 24'b0, data[7:0] };
			3'b001: 	data_out <= { { 16{ sign & data[15] } }, data[15:0] };
            3'b100: 	data_out <= { 16'b0, data[15:0] };
            default: 	data_out <= data;
        endcase
    end

endmodule