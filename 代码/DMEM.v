`timescale 1ns / 1ps

module DMEM(
    input 				clk,
    input 				ena,
    input 				wena,
    input [1:0] 		wsel,
    input [1:0] 		rsel, 
    input [31:0] 		data_in,
    input [31:0] 		addr,
    output reg [31:0] 	data_out
    );

	reg [31:0] store [1023:0];
	wire [11:0] new_addr = addr - 32'h10010000; 

    always@(posedge clk) 
	begin
        if(ena) 
		begin
            if(wena) begin
			case(wsel)
                2'b01: begin
					store[new_addr[11:2]] <= data_in; 
				end
                2'b10: begin
					case(new_addr[1:0])
						2'b00:	store[new_addr[11:2]][15:0]  <= data_in[15:0];
						2'b11:	store[new_addr[11:2]][31:16] <= data_in[15:0];
					endcase
				end
                2'b11: begin
					case(new_addr[1:0])
						2'b00:	store[new_addr[11:2]][7:0] 	 <= data_in[7:0];
						2'b01:	store[new_addr[11:2]][15:8]  <= data_in[7:0];
						2'b10:	store[new_addr[11:2]][23:16] <= data_in[7:0];
						2'b11:	store[new_addr[11:2]][31:24] <= data_in[7:0];
					endcase
				end
            endcase
            end
        end
    end

    always@(*) 
	begin
        if(ena && ~wena) begin
		case(rsel)
			2'b01: begin
				data_out <= store[new_addr[11:2]];
			end
			2'b10: begin
				case(new_addr[1:0])
					2'b00:data_out <= store[new_addr[11:2]][15:0];
					2'b10:data_out <= store[new_addr[11:2]][31:16];
				endcase
			end
			2'b11: begin
				case(new_addr[1:0])
					2'b00:	data_out <= store[new_addr[11:2]][7:0];
					2'b01:	data_out <= store[new_addr[11:2]][15:8];
					2'b10:	data_out <= store[new_addr[11:2]][23:16];
					2'b11:	data_out <= store[new_addr[11:2]][31:24];
				endcase
			end
		endcase
        end
    end
endmodule


