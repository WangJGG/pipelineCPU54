`timescale 1ns / 1ps

module MULT(  
    input           rst,
    input           ena,     
    input           sign, 
    input [31:0]    a,
    input [31:0]    b,
    output [31:0]   HI,
    output [31:0]   LO
    );

	reg [31:0] tmp_a;
	reg [31:0] tmp_b;
    reg [63:0] res,res_tmp;
    reg negative;
    integer i;
	
    always@(*) 
    begin
        if(rst) begin
		    tmp_a   <= 0;
            tmp_b   <= 0;
            res     <= 0;
            negative<= 0;
        end 
        else if(ena) 
        begin
            if(a == 0 || b == 0) begin
                res <= 0;
            end 
            else if(!sign) begin // unsigned multiplication
                res = 0;
                for(i = 0; i < 32; i = i + 1)  // compute the result
                begin
                    res_tmp = b[i] ?({ 32'b0, a } << i) : 64'b0;
                    res = res + res_tmp;       
                end
            end 
            else begin // signed multiplication
                res = 0;
                negative = a[31] ^ b[31]; // sign of result
                tmp_a = a;
                tmp_b = b;
                if(a[31]) begin
                    tmp_a = a ^ 32'hffffffff;
                    tmp_a = tmp_a + 1;
                end
                if(b[31]) begin
                    tmp_b = b ^ 32'hffffffff;
                    tmp_b = tmp_b + 1;
                end
                for(i = 0; i < 32; i = i + 1) // compute the result
                begin
                    res_tmp = tmp_b[i] ?({ 32'b0, tmp_a } << i):64'b0;
                    res = res + res_tmp;       
                end
                if(negative) 
                begin
                    res = res ^ 64'hffffffffffffffff;
                    res = res + 1;
                end
            end
        end
    end

	assign LO = ena ? res[31:0]  : 32'b0;
    assign HI = ena ? res[63:32] : 32'b0;
    
endmodule
