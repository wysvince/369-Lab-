`timescale 1ns / 1ps

module Fetch_Stage( Clk, Rst, Rst_ClkDiv, Branch_Fetch, JumpControl_Decode_Fetch, PCAdder_JReg_Memory_Fetch, 
                    JumpSL2_Decode_Fetch, PCResult_Fetch_Top,
					PCAdder_Fetch_IFID, INSTR_Fetch_IFID);

input Clk, Rst, Rst_ClkDiv;
input wire Branch_Fetch, JumpControl_Decode_Fetch;
input wire [31:0] PCAdder_JReg_Memory_Fetch;
input wire [31:0] JumpSL2_Decode_Fetch;
output wire [31:0] PCAdder_Fetch_IFID, INSTR_Fetch_IFID;
output reg [31:0] PCResult_Fetch_Top;

wire ClkOut;
wire [31:0] PCSrc_MuxJump, MuxJump_PC, PC_IM_PCAdder;
reg [3:0] PCAdderResult_Concat_SL2;
reg [31:0] JumpAddress_in;

ClkDiv ClkDiv_1(Clk, Rst_ClkDiv, ClkOut);

Mux32Bit2To1 PCSrc(PCSrc_MuxJump, PCAdder_Fetch_IFID, PCAdder_JReg_Memory_Fetch, Branch_Fetch);
ProgramCounter PC_1(MuxJump_PC, PC_IM_PCAdder, Rst, Clk);
InstructionMemory IM_1(PC_IM_PCAdder, INSTR_Fetch_IFID); 
PCAdder PCAdder_1(PC_IM_PCAdder, PCAdder_Fetch_IFID);

always@(PCAdder_Fetch_IFID, PC_IM_PCAdder, JumpSL2_Decode_Fetch)begin
    PCAdderResult_Concat_SL2 <= PCAdder_Fetch_IFID[31:28];
    JumpAddress_in <= {PCAdderResult_Concat_SL2,JumpSL2_Decode_Fetch[27:0]};
    PCResult_Fetch_Top <= PC_IM_PCAdder;
end

Mux32Bit2To1 MuxJump(MuxJump_PC, PCSrc_MuxJump, JumpAddress_in, JumpControl_Decode_Fetch);

endmodule