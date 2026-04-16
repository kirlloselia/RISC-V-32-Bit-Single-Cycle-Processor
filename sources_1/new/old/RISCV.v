`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2025 02:02:19 PM
// Design Name: 
// Module Name: RISCV
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


module RISCV(
    input clk,
    input reset
    );

    DATAPATH DATAPATH_inst
    (
        .clk(clk) ,	// input  clk_sig
        .reset(reset) 	// input  reset_sig
    );
endmodule
