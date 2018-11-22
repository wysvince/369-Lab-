`timescale 1ns / 1ps

module Decode_Stage(Clk, Rst,
                    INSTR_IFID_Decode, MemReg_WRITE_Decode, RtRd_MEMWB_Decode, RegWrite_MEMWB_Decode, JumpSL2_Decode_Fetch, JumpControl_Decode_Fetch,
                    RegDst_Decode_IDEX, ALUOp_Decode_IDEX, ALUSrc0_Decode_IDEX, ALUSrc1_Decode_IDEX, MuxStore_Decode_IDEX,   // EX
                    Branch_Decode_IDEX, MemRead_Decode_IDEX, MemWrite_Decode_IDEX,                           // M
                    RegWrite_Decode_IDEX, MemReg_Decode_IDEX, MuxLoad_Decode_IDEX, JRegControl_Decode_IDEX,   // WB
                    RS_Decode_IDEX, AddressRS_Decode_IDEX, RT_Decode_IDEX, AddressRT_Decode_IDEX, RD_Decode_IDEX, SignExt_Decode_IDEX, ZeroExt_Decode_IDEX);

input Clk, Rst;
input wire RegWrite_MEMWB_Decode;
input wire [31:0] RtRd_MEMWB_Decode;
input wire [31:0] INSTR_IFID_Decode, MemReg_WRITE_Decode;
output wire [5:0] ALUOp_Decode_IDEX; output wire [1:0] RegDst_Decode_IDEX, ALUSrc1_Decode_IDEX, ALUSrc0_Decode_IDEX;    // EX
output wire JRegControl_Decode_IDEX, JumpControl_Decode_Fetch, Branch_Decode_IDEX, MemRead_Decode_IDEX;                                                                // MEM
output wire RegWrite_Decode_IDEX, MemWrite_Decode_IDEX; output wire [1:0] MuxLoad_Decode_IDEX;                                                           // WB
output wire [31:0] RS_Decode_IDEX, RT_Decode_IDEX, SignExt_Decode_IDEX, ZeroExt_Decode_IDEX, JumpSL2_Decode_Fetch;
output reg [31:0] AddressRS_Decode_IDEX, AddressRT_Decode_IDEX, RD_Decode_IDEX;
output wire [1:0] MemReg_Decode_IDEX, MuxStore_Decode_IDEX;

reg [5:0] INSTR_OP, INSTR_5_0;  reg [4:0] INSTR_RS, INSTR_RT, INSTR_RD, INSTR_10_6;
reg [15:0] INSTR_IMMEOFFSET;
reg [31:0] readRsReg, readRtReg; // need 32bit inputs for Read Registers
reg [25:0] Jump_IM_SL2;

always@(Clk, Rst,INSTR_IFID_Decode, MemReg_WRITE_Decode, RtRd_MEMWB_Decode, RegWrite_MEMWB_Decode)begin
    {INSTR_OP, INSTR_RS, INSTR_RT, INSTR_RD, INSTR_10_6, INSTR_5_0} <= INSTR_IFID_Decode;
    INSTR_IMMEOFFSET = INSTR_IFID_Decode[15:0];
    RD_Decode_IDEX = INSTR_RD;
    readRsReg = INSTR_RS;
    readRtReg = INSTR_RT;
    AddressRS_Decode_IDEX = INSTR_RS;
    AddressRT_Decode_IDEX = INSTR_RT;
    Jump_IM_SL2 = INSTR_IFID_Decode[25:0];
end

ShiftLeft2 SL2_Jump({6'd0,Jump_IM_SL2}, JumpSL2_Decode_Fetch);

Controller Controller_1(  INSTR_OP, INSTR_RS, INSTR_RT, INSTR_10_6, INSTR_5_0, JumpControl_Decode_Fetch, JRegControl_Decode_IDEX,	            // F
                          RegDst_Decode_IDEX, ALUOp_Decode_IDEX, ALUSrc0_Decode_IDEX, ALUSrc1_Decode_IDEX, MuxStore_Decode_IDEX,   // EX
                          Branch_Decode_IDEX, MemRead_Decode_IDEX, MemWrite_Decode_IDEX,	                                       // M
                          MemReg_Decode_IDEX, RegWrite_Decode_IDEX, MuxLoad_Decode_IDEX);	                                       //WB

RegisterFile RegisterFile_1(readRsReg, readRtReg, RtRd_MEMWB_Decode, MemReg_WRITE_Decode, RegWrite_MEMWB_Decode, Clk, Rst, RS_Decode_IDEX, RT_Decode_IDEX);

SignExtension SignExtension_1(INSTR_IMMEOFFSET, SignExt_Decode_IDEX);

ZeroExtension ZeroExtension_1(INSTR_IMMEOFFSET, ZeroExt_Decode_IDEX);

endmodule