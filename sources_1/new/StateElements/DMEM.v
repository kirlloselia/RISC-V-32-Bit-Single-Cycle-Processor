`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2025 02:05:31 PM
// Design Name: 
// Module Name: DMEM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DMEM #(
    parameter WORD_DEPTH = 256
) (
    input clk, reset,
    input WE,
    input [31:0] ADDR, WD,
    //output reg [31:0] RD
    output [31:0] RD
);
    localparam BYTE_DEPTH = WORD_DEPTH << 2;
    reg [31:0] dmem [WORD_DEPTH-1:0];

    always @(posedge clk, negedge reset) begin
        if (!reset) begin: reset_block
            integer i;
            for (i = 0; i < WORD_DEPTH; i = i+1) begin
                dmem [i] <= 32'b0;
            end
        end
        else begin
            if (WE) begin
                dmem [ADDR] <= WD;
            end
        end
    end

    assign RD = dmem [ADDR];      // ***is this correct ??***
//    always @(*) begin           // ***is this correct ??***
//        if (!WE) begin
//            RD <= dmem [ADDR];
//        end
//        else begin
//			RD <= 32'bx;
//		end
//    end
endmodule