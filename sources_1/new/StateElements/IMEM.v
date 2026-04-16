`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2025 02:05:31 PM
// Design Name: 
// Module Name: IMEM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Instruction Memory for RISC-V, modeled as ROM, has one read port  
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module IMEM #(
    parameter WORD_DEPTH = 256
) (
    //input reset,
    input [31:0] ADDR,       // Byte Address
    output [31:0] RD
);
    localparam BYTE_DEPTH = WORD_DEPTH << 2;
    reg [31:0] imem [WORD_DEPTH-1:0];
    integer i;
    initial begin
        // Initialize specific memory locations with provided machine code
        imem[0]  = 32'h00100013;
        imem[1]  = 32'h00500113;
        imem[2]  = 32'h00C00193;
        imem[3]  = 32'hFF718393;
        imem[4]  = 32'h0023E233;
        imem[5]  = 32'h0041F2B3;
        imem[6]  = 32'h004282B3;
        imem[7]  = 32'h02728863;
        imem[8]  = 32'h0041A233;
        imem[9]  = 32'h00020463;
        imem[10] = 32'h00000293;
        imem[11] = 32'h0023A233;
        imem[12] = 32'h005203B3;
        imem[13] = 32'h402383B3;
        imem[14] = 32'h0471AA23;
        imem[15] = 32'h06002103;
        imem[16] = 32'h005104B3;
        imem[17] = 32'h008001EF;
        imem[18] = 32'h00100113;
        imem[19] = 32'h00910133;
        imem[20] = 32'h0221A023;
        imem[21] = 32'h00210063;

        // Initialize the rest of the memory to zero
        // Assumes WORD_DEPTH parameter is defined for the memory size
        for (i = 22; i < WORD_DEPTH; i = i + 1) begin
            imem[i] = 32'b0;
        end
    end
    
    assign RD = imem [ADDR[31:2]];
    
endmodule



// initial begin
//         // Initialize specific memory locations with provided machine code
//         imem[0]  = 32'h00100013;
//         imem[1]  = 32'h00500113;
//         imem[2]  = 32'h00C00193;
//         imem[3]  = 32'hFF718393;
//         imem[4]  = 32'h0023E233;
//         imem[5]  = 32'h0041F2B3;
//         imem[6]  = 32'h004282B3;
//         imem[7]  = 32'h02728863;
//         imem[8]  = 32'h0041A233;
//         imem[9]  = 32'h00020463;
//         imem[10] = 32'h00000293;
//         imem[11] = 32'h0023A233;
//         imem[12] = 32'h005203B3;
//         imem[13] = 32'h402383B3;
//         imem[14] = 32'h0471AA23;
//         imem[15] = 32'h06002103;
//         imem[16] = 32'h005104B3;
//         imem[17] = 32'h008001EF;
//         imem[18] = 32'h00100113;
//         imem[19] = 32'h00910133;
//         imem[20] = 32'h0221A023;
//         imem[21] = 32'h00210063;

//         // Initialize the rest of the memory to zero
//         // Assumes WORD_DEPTH parameter is defined for the memory size
//         for (i = 22; i < WORD_DEPTH; i = i + 1) begin
//             imem[i] = 32'b0;
//         end
//     end
// initial begin
//     // Initialize specific memory locations with provided machine code
//     imem[0]  = 32'h00500113;
//     imem[1]  = 32'h00C00193;
//     imem[2]  = 32'hFF718393;
//     imem[3]  = 32'h0023E233;
//     imem[4]  = 32'h0041F2B3;
//     imem[5]  = 32'h004282B3;
//     imem[6]  = 32'h02728863;
//     imem[7]  = 32'h0041A233;
//     imem[8]  = 32'h00020463;
//     imem[9]  = 32'h00000293;
//     imem[10] = 32'h0023A233;
//     imem[11] = 32'h005203B3;
//     imem[12] = 32'h402383B3;
//     imem[13] = 32'h0471AA23;
//     imem[14] = 32'h06002103;
//     imem[15] = 32'h005104B3;
//     imem[16] = 32'h008001EF;
//     imem[17] = 32'h00100113;
//     imem[18] = 32'h00910133;
//     imem[19] = 32'h0221A023;
//     imem[20] = 32'h00210063;

//     // Initialize the rest of the memory to zero
//     // Assumes WORD_DEPTH parameter is defined for the memory size
//     for (i = 21; i < WORD_DEPTH; i = i + 1) begin
//         imem[i] = 32'b0;
//     end
// end


//initial $readmemh("instructions.mem", imem);
    // initial begin
    //     imem[0] = 32'hFFC4A303;                         // L7: lw x6, -4(x9)
    //     imem[1] = 32'h0064A423;                         // sw x6, 8(x9)
    //     imem[2] = 32'h0062E233;                         // or x4, x5, x6
    //     imem[3] = 32'hFE420AE3;                         // beq x4, x4, L7
    //     for (i = 4; i < WORD_DEPTH; i = i+1) begin
    //         imem [i] = 32'b0;
    //     end
    // end



    // always @(*) begin
    //     // Initialize specific memory locations with provided machine code
    //     imem[0]  <= 32'h00100013;
    //     imem[1]  <= 32'h00500113;
    //     imem[2]  <= 32'h00C00193;
    //     imem[3]  <= 32'hFF718393;
    //     imem[4]  <= 32'h0023E233;
    //     imem[5]  <= 32'h0041F2B3;
    //     imem[6]  <= 32'h004282B3;
    //     imem[7]  <= 32'h02728863;
    //     imem[8]  <= 32'h0041A233;
    //     imem[9]  <= 32'h00020463;
    //     imem[10] <= 32'h00000293;
    //     imem[11] <= 32'h0023A233;
    //     imem[12] <= 32'h005203B3;
    //     imem[13] <= 32'h402383B3;
    //     imem[14] <= 32'h0471AA23;
    //     imem[15] <= 32'h06002103;
    //     imem[16] <= 32'h005104B3;
    //     imem[17] <= 32'h008001EF;
    //     imem[18] <= 32'h00100113;
    //     imem[19] <= 32'h00910133;
    //     imem[20] <= 32'h0221A023;
    //     imem[21] <= 32'h00210063;

    //     // Initialize the rest of the memory to zero
    //     // Assumes WORD_DEPTH parameter is defined for the memory size
    //     for (i = 22; i < WORD_DEPTH; i = i + 1) begin
    //         imem[i] <= 32'b0;
    //     end
    // end