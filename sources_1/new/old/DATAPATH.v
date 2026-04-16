`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2025 08:39:29 PM
// Design Name: 
// Module Name: DATAPATH
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


module DATAPATH(
    input clk,
    input reset
    );

    // wire decl

    wire [31:0] PC_sig, PCNext_sig;

    wire [31:0] Instr_sig;

    wire [31:0] PCPlus4_sig;

    wire PCSrc_sig;
    wire [1:0] ResultSrc_sig;
    wire MemWrite_sig;
    wire ALUSrc_sig;
    wire [1:0] ImmSrc_sig;
    wire RegWrite_sig;
    wire [2:0] ALUControl_sig;

    wire [31:0] SrcA_sig, WriteData_sig, SrcB_sig;

    wire [31:0] ImmExt_sig;

    wire [31:0] PCTarget_sig;

    wire [31:0] ALUResult_sig;
    wire zero_flag_sig;

    wire [31:0] ReadData_sig;

    wire [31:0] Result_sig;

    PC PC_inst
    (
        .clk(clk) ,	// input  clk_sig
        .reset(reset) ,	// input  reset_sig
        .PCNext(PCNext_sig) ,	// input [(N-1):0] PCNext_sig
        .PC(PC_sig) 	// output [(N-1):0] PC_sig
    );

    IMEM IMEM_inst
    (
       // .reset(reset),  // input reset
        .ADDR(PC_sig) ,	// input [31:0] ADDR_sig
        .RD(Instr_sig) 	// output [31:0] RD_sig
    );

    ADDER ADDER_PCPlus4_int
    (
        .A(PC_sig),
        .B(32'd4),
        .result(PCPlus4_sig)
    );

    mux2_1 mux2_1_PCNext_inst 
    (
        .A(PCPlus4_sig),
        .B(PCTarget_sig),
        .sel(PCSrc_sig),
        .result(PCNext_sig)
    );

    ControlUnit ControlUnit_inst
    (
        .zero_flag(zero_flag_sig) ,	// input  zero_flag_sig
        .funct3(Instr_sig[14:12]) ,	// input [2:0] funct3_sig
        .funct7_5(Instr_sig[30]) ,	// input  funct7_5_sig
        .op(Instr_sig[6:0]) ,	// input [6:0] op_sig
        .PCSrc(PCSrc_sig) ,	// output  PCSrc_sig
        .ResultSrc(ResultSrc_sig) ,	// output [1:0] ResultSrc_sig
        .MemWrite(MemWrite_sig) ,	// output  MemWrite_sig
        .ALUSrc(ALUSrc_sig) ,	// output  ALUSrc_sig
        .ImmSrc(ImmSrc_sig) ,	// output [1:0] ImmSrc_sig
        .RegWrite(RegWrite_sig) ,	// output  RegWrite_sig
        .ALUControl(ALUControl_sig) 	// output [2:0] ALUControl_sig
    );

    REGFILE REGFILE_inst
    (
        .clk(clk) ,	// input  clk_sig
        .reset(reset) ,	// input  reset_sig
        .WE3(RegWrite_sig) ,	// input  WE3_sig
        .ADDR1(Instr_sig[19:15]) ,	// input [4:0] ADDR1_sig
        .ADDR2(Instr_sig[24:20]) ,	// input [4:0] ADDR2_sig
        .ADDR3(Instr_sig[11:7]) ,	// input [4:0] ADDR3_sig
        .WD3(Result_sig) ,	// input [31:0] WD3_sig             
        .RD1(SrcA_sig) ,	// output [31:0] RD1_sig
        .RD2(WriteData_sig) 	// output [31:0] RD2_sig
    );

    mux2_1 mux2_1_SrcB_inst 
    (
        .A(WriteData_sig),
        .B(ImmExt_sig),
        .sel(ALUSrc_sig),
        .result(SrcB_sig)
    );

    EXTEND EXTEND_inst
    (
        .Instr(Instr_sig[31:7]) ,	// input [31:7] Instr_sig
        .ImmSrc(ImmSrc_sig) ,	// input [1:0] ImmSrc_sig
        .ImmExt(ImmExt_sig) 	// output [31:0] ImmExt_sig
    );

    ADDER ADDER_PCTarget_int
    (
        .A(PC_sig),
        .B(ImmExt_sig),
        .result(PCTarget_sig)
    );

    
    ALU ALU_inst
    (
        .A(SrcA_sig) ,	// input [(WIDTH-1):0] A_sig
        .B(SrcB_sig) ,	// input [(WIDTH-1):0] B_sig
        .sel(ALUControl_sig) ,	// input [2:0] sel_sig
        .result(ALUResult_sig) ,	// output [(WIDTH-1):0] result_sig
        .zero_flag(zero_flag_sig) 	// output  zero_flag_sig
    );

    DMEM DMEM_inst
    (
        .clk(clk) ,	// input  clk_sig
        .reset(reset) ,	// input  reset_sig
        .WE(MemWrite_sig) ,	// input  WE_sig
        .ADDR(ALUResult_sig) ,	// input [31:0] ADDR_sig
        .WD(WriteData_sig) ,	// input [31:0] WD_sig
        .RD(ReadData_sig) 	// output [31:0] RD_sig
    );

    mux3_1 mux3_1_Result_inst 
    (
        .A(ALUResult_sig),
        .B(ReadData_sig),
        .C(PCPlus4_sig),
        .sel(ResultSrc_sig),
        .result(Result_sig)
    );
endmodule
