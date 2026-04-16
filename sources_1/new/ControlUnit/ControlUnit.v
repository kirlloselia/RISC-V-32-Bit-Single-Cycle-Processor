`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2025 08:25:51 PM
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input zero_flag,
    input [2:0] funct3,
    input funct7_5,       // funct7_5
    input [6:0] op,
    output PCSrc,
    output [1:0] ResultSrc,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [2:0] ALUControl
    );
    wire Branch, Jump;
    wire [1:0] ALUOp;

    Main_Decoder Main_Decoder_inst
    (
        .op(op) ,	// input [6:0] op
        .Branch(Branch) ,	// output  Branch
        .Jump(Jump) ,	// output  Jump
        .ResultSrc(ResultSrc) ,	// output [1:0] ResultSrc
        .MemWrite(MemWrite) ,	// output  MemWrite
        .ALUSrc(ALUSrc) ,	// output  ALUSrc
        .ImmSrc(ImmSrc) ,	// output [1:0] ImmSrc
        .RegWrite(RegWrite) ,	// output  RegWrite
        .ALUOp(ALUOp) 	// output [1:0] ALUOp
    );

    assign PCSrc = (zero_flag & Branch) | Jump;

    ALU_Decoder ALU_Decoder_inst
    (
        .funct3(funct3),
        .funct7_5(funct7_5),       // funct7_5
        .ALUOp(ALUOp),
        .op_5(op[5]),           // op_5
        .ALUControl(ALUControl)
    );
endmodule
