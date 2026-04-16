`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2025 07:17:27 PM
// Design Name: 
// Module Name: ALU_Decoder
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


module ALU_Decoder(
    input [2:0] funct3,
    input funct7_5,       // funct7_5
    input [1:0] ALUOp,
    input op_5,           // op_5
    output reg [2:0] ALUControl
    );
    always @(*) begin
        case (ALUOp)
            2'b00:     ALUControl = 3'b000;   // lw, sw
            2'b01:     ALUControl = 3'b001;   // beq
            2'b10:      
                    case (funct3)
                        3'b000:
                                case ({op_5, funct7_5})
                                    2'b00, 2'b01, 2'b10: ALUControl = 3'b000;   // addi, add
                                    2'b11: ALUControl = 3'b001;   // sub
                                    default: ALUControl = 3'bxxx;
                                endcase 
                        3'b010: ALUControl = 3'b101;            // slt
                        3'b110: ALUControl = 3'b011;            // or
                        3'b111: ALUControl = 3'b010;            // and
                        3'b100: ALUControl = 3'b100;            // xor
                        3'b001: ALUControl = 3'b110;            // sll
                        3'b101: case ({op_5, funct7_5})
                                    2'b00, 2'b10: ALUControl = 3'b111;   // srl, srli
                                    default: ALUControl = 3'bxxx;
                                endcase
                        default: ALUControl = 3'bxxx;
                    endcase
            default:   ALUControl = 3'bxxx;
        endcase
    end
endmodule
