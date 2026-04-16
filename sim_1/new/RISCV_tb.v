`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2025 10:01:22 PM
// Design Name: 
// Module Name: RISCV_tb
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


module RISCV_tb(
    );
    reg clk, reset;
    parameter clk_period = 10;
    initial begin
        clk = 0;
        reset = 0; #1
        reset = 1;
        forever begin
            #(clk_period/2)
            clk = ~clk;
        end
    end
    always @(negedge clk) begin
        $display("PC:\t%h", dut.DATAPATH_inst.PC_sig);
        if(dut.DATAPATH_inst.MemWrite_sig) begin
            if(dut.DATAPATH_inst.ALUResult_sig === 104 & dut.DATAPATH_inst.WriteData_sig === 25) begin
            // if(dut.DATAPATH_inst.ALUResult_sig === 100 & dut.DATAPATH_inst.WriteData_sig === 25) begin   // if no instruc added
                $display("Simulation succeeded");
                $stop;
            end else if (dut.DATAPATH_inst.ALUResult_sig !== 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end
    RV32I dut (
        .fun_clk(clk),
        .fun_rst_n(reset),
        .test_mode(1'b0),
        .scan_clk(),
        .scan_rst_n()
    );
endmodule
