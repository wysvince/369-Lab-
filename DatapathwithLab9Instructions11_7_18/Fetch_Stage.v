`timescale 1ns / 1ps

module Fetch_Stage( Clk, Rst, BranchResult_in, JumpControl_in, PCAdder_JReg_PCSrc, 
                    SL2_JumpMux_in, PC_IM_PCAdder,
					PCAdder_out, Instruction_out);

input Clk, Rst;
input wire BranchResult_in, JumpControl_in;
input wire [31:0] PCAdder_JReg_PCSrc;
input wire [31:0] SL2_JumpMux_in;
output wire [31:0] PCAdder_out, Instruction_out;

wire ClkOut;
wire [31:0] PCSrc_MuxJump, MuxJump_PC;
output wire [31:0] PC_IM_PCAdder;
reg [31:0] JumpAddress_in;

Mux32Bit2To1 PCSrc(PCSrc_MuxJump, PCAdder_out, PCAdder_JReg_PCSrc, BranchResult_in);
ProgramCounter PC_1(MuxJump_PC, PC_IM_PCAdder, Rst, Clk);
InstructionMemory IM_1(PC_IM_PCAdder, Instruction_out); 
PCAdder PCAdder_1(PC_IM_PCAdder, PCAdder_out);

always@(PCAdder_out, SL2_JumpMux_in)begin
    JumpAddress_in <= {PCAdder_out[31:28], SL2_JumpMux_in[27:0]};
end

Mux32Bit2To1 MuxJump(MuxJump_PC, PCSrc_MuxJump, JumpAddress_in, JumpControl_in);

endmodule