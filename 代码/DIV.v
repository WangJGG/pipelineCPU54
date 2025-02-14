`timescale 1ns / 1ps

module DIV(
    input           rst,
    input           ena,
    input           sign,
    input [31:0]    a, // dividend
    input [31:0]    b, // divisor
    output [31:0]   q, // quotient
    output [31:0]   r  // remainder
    );

    reg negative;
    reg dividend_neg;// sign of result
    reg [63:0] dividend;
    reg [63:0] divisor;

    integer i;
	
    always@(*) 
    begin
        if(rst) begin
            dividend    <= 0;
            divisor     <= 0;
            negative    <= 0;
            dividend_neg<= 0;
        end 
        else if(ena) 
        begin
            if(sign) begin // unsigned division
                dividend = a;
                divisor = { b, 32'b0 }; 
                for(i = 0; i < 32; i = i + 1) // compute the result
                begin
                    dividend = dividend << 1;
                    if(dividend >= divisor)
                    begin
                        dividend = dividend - divisor;
                        dividend = dividend + 1;
                    end
                end
                i = 0;
            end 
            else // signed division
            begin
                dividend    <= a;
                divisor     <= { b, 32'b0 };
                negative    <= a[31] ^ b[31];
                dividend_neg<= a[31];
                
                if(a[31]) begin
					dividend = a ^ 32'hffffffff;
					dividend = dividend + 1;
                end
                if(b[31]) begin
                    divisor = {b ^ 32'hffffffff, 32'b0};
                    divisor = divisor + 64'h0000000100000000;
                end 
                for(i = 0; i < 32; i = i + 1) // compute the result
                begin
                    dividend = dividend << 1;
                    if(dividend >= divisor) 
                    begin
                        dividend = dividend - divisor;
                        dividend = dividend + 1;
                    end
                end
                if(dividend_neg) begin //adjust the sign of result
                    dividend = dividend ^ 64'hffffffff00000000;
                    dividend = dividend + 64'h0000000100000000;
                end          
                if(negative) begin     //adjust the sign of result
                    dividend = dividend ^ 64'h00000000ffffffff;
                    dividend = dividend + 64'h0000000000000001;
                    if(dividend[31:0] == 32'b0) 
                        dividend = dividend - 64'h0000000100000000;
                end
            end
        end
    end
    
	assign q = ena ? dividend[31:0] : 32'b0;
    assign r = ena ? dividend[63:32]: 32'b0;

endmodule
