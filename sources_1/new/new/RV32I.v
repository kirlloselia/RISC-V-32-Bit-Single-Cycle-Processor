`timescale 1ns / 1ps
`include "DATAPATH.v"
`include "ALUs/ALU.v"
`include "ALUs/ADDER.v"

`include "ControlUnit/ALU_Decoder.v"
`include "ControlUnit/Main_Decoder.v"
`include "ControlUnit/ControlUnit.v"

`include "EXTEND/EXTEND.V"

`include "MUXes/mux2_1.v"
`include "MUXes/mux3_1.v"

`include "StateElements/IMEM.v"
`include "StateElements/DMEM.v"
`include "StateElements/PC.v"
`include "StateElements/REGFILE.v"
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


module RV32I(
    input fun_clk, scan_clk,
    input test_mode,
    input fun_rst_n, scan_rst_n,
    output [15:0] ALUResult_15_0, PC_15_0
    );
    wire clk, reset;
    assign clk = test_mode ? scan_clk : fun_clk;
    assign reset = test_mode ? scan_rst_n : fun_rst_n;
   
    wire [15:0] ALUResult_sig, PC_sig;

    DATAPATH DATAPATH_inst
    (
        .clk(clk) ,	// input  clk_sig
        .reset(reset), 	// input  reset_sig
        .ALUResult(ALUResult_sig),   // ouptut [15:0] ALUResult
        .PC(PC_sig)         // ouptut [15:0] PC
    );
    assign ALUResult_15_0 = ALUResult_sig;
    assign PC_15_0 = PC_sig;
endmodule
