`include "MIPS.vh"
`timescale 1ns / 1ps

module Forwarder(
    input               clk,
    input               rst,
    input [5:0]         op,
    input [5:0]         func,
    input               rs_rena,
    input               rt_rena,
    input [4:0]         rsc,
    input [4:0]         rtc,

    input [5:0]         EX_op,
    input [5:0]         EX_func,
    input [31:0]        EX_hi_data,
    input [31:0]        EX_lo_data,
    input [31:0]        EX_rd_data,
    input               EX_hi_wena,
    input               EX_lo_wena,
    input               EX_rd_wena,
    input [4:0]         EX_rdc,

    input [31:0]        MEM_hi_data,
    input [31:0]        MEM_lo_data,
    input [31:0]        MEM_rd_data,
    input               MEM_hi_wena,
    input               MEM_lo_wena,
    input               MEM_rd_wena,
    input [4:0]         MEM_rdc,

    output reg          stall_out,
    output reg          forward_out,
    output reg          rs_correlation_out,
    output reg          rt_correlation_out,
    output reg [31:0]   rs_data_out,
    output reg [31:0]   rt_data_out,
    output reg [31:0]   hi_data_out,
    output reg [31:0]   lo_data_out
    );


    always@(negedge clk or posedge rst) 
    begin
        if(rst) 
        begin
            stall_out       <= 1'b0;
            rs_data_out     <= 32'b0;
            rt_data_out     <= 32'b0;
            hi_data_out     <= 32'b0;
            lo_data_out     <= 32'b0;
            forward_out  <= 1'b0;
            rs_correlation_out       <= 1'b0;
            rt_correlation_out       <= 1'b0;
        end 
        else if(stall_out&~rst) 
        begin
            stall_out <= 1'b0;
            if(rs_correlation_out) 
                rs_data_out <= MEM_rd_data;
            else if(rt_correlation_out)
                rt_data_out <= MEM_rd_data;
        end 
        else//~out_stall&~rst
        begin
            forward_out = 0;
            rs_correlation_out = 0;
            rt_correlation_out = 0;
            if(op == `MFHI_op && func == `MFHI_func) 
            begin
                if(EX_hi_wena) 
                begin
                    hi_data_out     <= EX_hi_data;
                    forward_out  <= 1'b1;
                end 
                else if(MEM_hi_wena) 
                begin
                    hi_data_out     <= MEM_hi_data;
                    forward_out  <= 1'b1;
                end
            end 
            else if(op == `MFLO_op && func == `MFLO_func) 
            begin
                if(EX_lo_wena) 
                begin
                    lo_data_out     <= EX_lo_data;
                    forward_out  <= 1'b1;
                end 
                else if(MEM_lo_wena) 
                begin
                    lo_data_out     <= MEM_lo_data;
                    forward_out  <= 1'b1;
                end
            end 
            else 
            begin
                // rs的相关分析
                if(EX_rd_wena && rs_rena && EX_rdc == rsc) 
                begin
                    if(EX_op == `LW_op || EX_op == `LH_op || EX_op == `LHU_op || EX_op == `LB_op || EX_op == `LBU_op) 
                    begin
                        rs_correlation_out  <= 1'b1;
                        stall_out           <= 1'b1;
                        forward_out      <= 1'b1;
                    end
                    else 
                    begin
                        rs_correlation_out  <= 1'b1;
                        rs_data_out         <= EX_rd_data;
                        forward_out      <= 1'b1;
                    end
                end
                else if(MEM_rd_wena && rs_rena && MEM_rdc == rsc) 
                begin
                    rs_correlation_out  <= 1'b1;
                    rs_data_out         <= MEM_rd_data;
                    forward_out      <= 1'b1;
                end
                else ;

                // rt的相关分析
                if(EX_rd_wena && rt_rena && EX_rdc == rtc) 
                begin
                    if(EX_op == `LW_op || EX_op == `LH_op || EX_op == `LHU_op || EX_op == `LB_op || EX_op == `LBU_op) 
                    begin
                        rt_correlation_out  <= 1'b1;
                        stall_out           <= 1'b1;
                        forward_out      <= 1'b1;
                    end 
                    else 
                    begin
                        rt_correlation_out  <= 1'b1;
                        rt_data_out         <= EX_rd_data;
                        forward_out      <= 1'b1;
                    end
                end 
                else if(MEM_rd_wena && rt_rena && MEM_rdc == rtc) 
                begin
                    rt_correlation_out  <= 1'b1;
                    rt_data_out         <= MEM_rd_data;
                    forward_out      <= 1'b1;
                end
                else ;
            end
        end
	end      

endmodule