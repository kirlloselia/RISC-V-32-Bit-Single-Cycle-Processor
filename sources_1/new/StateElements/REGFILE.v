`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2025 02:05:31 PM
// Design Name: 
// Module Name: REGFILE
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


module REGFILE(
    input clk, reset,
    input WE3,
    input [4:0] ADDR1, ADDR2, ADDR3,
    input [31:0] WD3,
    output [31:0] RD1, RD2
    );

    reg [31:0] regfile [31:0];

    always @(posedge clk, negedge reset) begin
        if (!reset) begin: reset_block
            integer i;
            for (i = 0; i < 32; i = i+1) begin
                regfile [i] <= 32'b0;
            end
        end
        else begin
            if (WE3) begin
                if (| ADDR3) begin
                    regfile [ADDR3] <= WD3;
                end
                else;
                //regfile [0] <= 32'b0;       // x0 Hardcoded to zero, Is this correct???
            end
        end
    end

    // x0 Hardcoded to zero, Is this correct??? AVOID RACE CONDITION? DON"T READ FROM x0!
    assign RD1 = (~| ADDR1) ? 0 : regfile [ADDR1];
    assign RD2 = (~| ADDR2) ? 0 : regfile [ADDR2];

endmodule
