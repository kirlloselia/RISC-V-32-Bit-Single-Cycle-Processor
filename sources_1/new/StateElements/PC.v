`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2025 02:05:31 PM
// Design Name: 
// Module Name: PC
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

module PC #(
    parameter N = 32
) (
    input clk, reset, 
    input [N-1:0] PCNext,
    output reg [N-1:0] PC
);
    always @(posedge clk, negedge reset) begin
        if(!reset) begin
            PC <= 0;
        end
        else begin
            PC <= PCNext;
        end
    end
endmodule