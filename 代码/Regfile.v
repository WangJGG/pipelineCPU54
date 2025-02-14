`timescale 1ns / 1ps

module Regfile(
    input               clk, 
    input               rst, 
    input               rd_wena, 
    input   [4:0]       rs_addr, 
    input   [4:0]       rt_addr, 
    input               rs_ena,
    input               rt_ena,
    input   [4:0]       rd_addr, 
    input   [31:0]      rd_data, 
    output reg [31:0]   rs_data_out, 
    output reg [31:0]   rt_data_out,
    output [31:0]       reg_17,
    output [31:0]       reg_18
);

    reg [31:0] array_reg [31:0];
    integer i;

    // Reset logic to initialize registers
    always@(posedge clk or posedge rst) 
    begin
        if(rst) 
        begin
            for(i = 0; i < 32; i = i + 1) 
                array_reg[i] <= 32'b0;
        end 
        else if(rd_wena && (rd_addr != 0)) 
            array_reg[rd_addr] <= rd_data;
    end

    // Generalized data output assignment logic for rs_data_out and rt_data_out
    always@(*) 
    begin
        // Handle rs_data_out
        if (rst) 
            rs_data_out <= 32'b0;
        else if (rs_addr == 5'b0) 
            rs_data_out <= 32'b0;
        else if (rd_wena && rs_ena && (rs_addr == rd_addr)) 
            rs_data_out <= rd_data;
        else if (rs_ena) 
            rs_data_out <= array_reg[rs_addr];
        else 
            rs_data_out <= 32'bz;

        // Handle rt_data_out
        if (rst) 
            rt_data_out <= 32'b0;
        else if (rt_addr == 5'b0) 
            rt_data_out <= 32'b0;
        else if (rd_wena && rt_ena && (rt_addr == rd_addr)) 
            rt_data_out <= rd_data;
        else if (rt_ena) 
            rt_data_out <= array_reg[rt_addr];
        else 
            rt_data_out <= 32'bz;
    end

    // Output c[i] d[i]
    assign reg_17 = array_reg[17];
    assign reg_18 = array_reg[18];
    

endmodule
