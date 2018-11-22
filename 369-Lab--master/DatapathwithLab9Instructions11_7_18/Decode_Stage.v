`timescale 1ns / 1ps

module Decode_Stage(Clk, Rst,
                    Instruction_in, WriteData_in, WriteRegDst_in, RegWrite_in, Jump_SL2_Fetch, JumpControl_out,
                    RegDst_out, ALUOp_out, ALUSrc0_out, ALUSrc1_out, MuxStore_out,   // EX
                    Branch_out, MemRead_out, MemWrite_out,                           // M
                    RegWrite_out, MemReg_out, MuxLoad_out, JRegControl_out,   // WB
                    Rs_out, AddressRs_out, Rt_out, AddressRt_out, Rd_out, SignExt_out, ZeroExt_out);

input Clk, Rst;
input wire RegWrite_in;
input wire [31:0] WriteRegDst_in;
input wire [31:0] Instruction_in, WriteData_in;
output wire [5:0] ALUOp_out; output wire [1:0] RegDst_out, ALUSrc1_out, ALUSrc0_out;    // EX
output wire JRegControl_out, JumpControl_out, Branch_out, MemRead_out;                                                                // MEM
output wire RegWrite_out, MemWrite_out; output wire [1:0] MuxLoad_out;                                                           // WB
output wire [31:0] Rs_out, Rt_out, SignExt_out, ZeroExt_out, Jump_SL2_Fetch;
output reg [31:0] AddressRs_out, AddressRt_out, Rd_out;
output wire [1:0] MemReg_out, MuxStore_out;

reg [5:0] INSTR_OP, INSTR_5_0;  reg [4:0] INSTR_RS, INSTR_RT, INSTR_RD, INSTR_10_6;
reg [15:0] INSTR_IMMEOFFSET;
reg [31:0] readRsReg, readRtReg; // need 32bit inputs for Read Registers
reg [25:0] Jump_IM_SL2;

always@(*)begin
    {INSTR_OP, INSTR_RS, INSTR_RT, INSTR_RD, INSTR_10_6, INSTR_5_0} <= Instruction_in;
    INSTR_IMMEOFFSET <= Instruction_in[15:0];
    Rd_out <= INSTR_RD;
    readRsReg <= INSTR_RS;
    readRtReg <= INSTR_RT;
    AddressRs_out <= INSTR_RS;
    AddressRt_out <= INSTR_RT;
    Jump_IM_SL2 <= Instruction_in[25:0];
end

ShiftLeft2 SL2_Jump({6'd0,Jump_IM_SL2}, Jump_SL2_Fetch);

Controller Controller_1(  INSTR_OP, INSTR_RS, INSTR_RT, INSTR_10_6, INSTR_5_0, JumpControl_out, JRegControl_out,	            // F
                          RegDst_out, ALUOp_out, ALUSrc0_out, ALUSrc1_out, MuxStore_out,   // EX
                          Branch_out, MemRead_out, MemWrite_out,	                                       // M
                          MemReg_out, RegWrite_out, MuxLoad_out);	                                       //WB

RegisterFile RegisterFile_1(readRsReg, readRtReg, WriteRegDst_in, WriteData_in, RegWrite_in, Clk, Rst, Rs_out, Rt_out);

SignExtension SignExtension_1(INSTR_IMMEOFFSET, SignExt_out);

ZeroExtension ZeroExtension_1(INSTR_IMMEOFFSET, ZeroExt_out);

endmodule