`timescale 1ns / 1ps

module InstructionFetchUnit(BranchResult, EXMEM_in, PCAdder_out, Instruction_out, Rst, Clk);

    input wire Rst, Clk, BranchResult;
    input wire [31:0] EXMEM_in;
    output wire [31:0] Instruction_out;
    output reg [31:0] PCAdder_out;
    wire [31:0] PCSrc_PC, PC_IM, PC_PCAdder, PCAdder_PCSrc;
    
    InstructionMemory InstructionMemory_1(PC_IM, Instruction_out);
    
    ProgramCounter ProgramCounter_1(PCSrc_PC, PC_IM, Rst, Clk);
    
    PCAdder PCAdder_1(PC_IM, PCAdder_PCSrc);
    
    always@(PCAdder_PCSrc) begin
        PCAdder_out <= PCAdder_PCSrc;
    end
    
    Mux32Bit2To1 PCSrc(PCSrc_PC, PCAdder_PCSrc, EXMEM_in, BranchResult);
   
endmodule

