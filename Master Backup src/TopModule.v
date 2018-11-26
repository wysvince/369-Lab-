`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Vincent Wong 50% & Abdi Tasir 50%
// 
// ECE369A - Computer Architecture
// Laboratory 9
// Module - TopModule.v
///////////////////////////////////////////////////////////////////////////////

module TopModule(Clk, Rst, Rst_ClkDiv, PC_output, WriteData_output, HiReg_output, LoReg_output);

input Clk, Rst, Rst_ClkDiv;
output reg [31:0] PC_output, WriteData_output, HiReg_output, LoReg_output;
reg [31:0] PullHiReg_output, PullLoReg_output;//wire [31:0] PullHiReg_output, PullLoReg_output

wire [31:0] PCAdder_Fetch_IFID, INSTR_Fetch_IFID, JumpSL2_Decode_Fetch, PCAdder_JReg_Memory_Fetch;
wire Branch_Fetch, JumpControl_Decode_Fetch; 
wire [31:0] PCAdder_IFID_IDEX, INSTR_IFID_Decode;
reg [31:0] AddressRs_Decode_IDEX, AddressRt_Decode_IDEX, RD_Decode_IDEX;//switched from for decode stage: wire [31:0] AddressRs_Decode_IDEX, AddressRt_Decode_IDEX, RD_Decode_IDEX
wire [31:0] RtRd_MEMWB_Decode, RS_Decode_IDEX,RT_Decode_IDEX, SignExt_Decode_IDEX, ZeroExt_Decode_IDEX;
wire RegWrite_MEMWB_Decode, Branch_Decode_IDEX, MemRead_Decode_IDEX, RegWrite_Decode_IDEX, JRegControl_Decode_IDEX, JRegControl_IDEX_EXMEM;
wire [5:0] ALUOp_Decode_IDEX;
wire [1:0] RegDst_Decode_IDEX, ALUSrc1_Decode_IDEX, ALUSrc0_Decode_IDEX, MuxStore_Decode_IDEX, MuxLoad_Decode_IDEX;
wire [31:0] MemReg_WRITE_Decode;
wire MemWrite_Decode_IDEX;//switched MemWrite_Decode_IDEX from 1'b to 2'b wrong should be 1
wire [31:0] PCAdder_IDEX_Execution, RS_IDEX_Execution, RT_IDEX_Execution, AddressRs_IDEX_Execution, AddressRt_IDEX_Execution, RD_IDEX_Execution, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution;
wire Branch_IDEX_EXMEM, JRegControl_EXMEM_Memory, 
     MemRead_IDEX_EXMEM, MemWrite_IDEX_EXMEM, RegWrite_IDEX_EXMEM;
wire [5:0] ALUOp_IDEX_Execution;
wire [1:0] RegDst_IDEX_Execution, ALUSrc0_IDEX_Execution, ALUSrc1_IDEX_Execution, MuxStore_IDEX_Execution, MuxLoad_IDEX_EXMEM;

wire [31:0] PCAdder_IDEX_Execution_EXMEM, RS_EXMEM_Memory, PCAdder_EXMEM_Memory, ALUResult_Execution_EXMEM, RT_Execution_EXMEM, RtRd_Execution_EXMEM, PCAdder_Execution_EXMEM;
wire ZERO_Execution_EXMEM;

wire Branch_EXMEM_Memory, MemRead_EXMEM_Memory, MemWrite_EXMEM_Memory, RegWrite_EXMEM_MEMWB, ZERO_EXMEM_Memory;
wire [1:0] MuxLoad_EXMEM_Memory;
wire [31:0] PC2ndAdder_MEMWB_Write, ALUResult_EXMEM_Memory_MEMWB, RT_EXMEM_Memory, RtRd_EXMEM_MEMWB;

wire [31:0] RT_Memory_MEMWB;

wire  [1:0] MemReg_MEMWB_WRITE, MemReg_EXMEM_MEMWB, MemReg_IDEX_EXMEM, MemReg_Decode_IDEX; 
wire [31:0] PC2Adder_EXMEM_MEMWB, LoadData_MEMWB_WRITE, ALUResult_MEMWB_WRITE; 
reg [31:0] PCResult_Fetch_Top;//switched to from for Fetch Stage wire [31:0] PCResult_Fetch_Top; 

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//#FETCH STAGE#

//Fetch_Stage Fetch_Stage_1( Clk, Rst, Rst_ClkDiv, Branch_Fetch, JumpControl_Decode_Fetch, PCAdder_JReg_Memory_Fetch, 
//                            JumpSL2_Decode_Fetch, PCResult_Fetch_Top,
//                            PCAdder_Fetch_IFID, INSTR_Fetch_IFID);

                            
wire ClkOut;
wire [31:0] PCSrc_MuxJump, MuxJump_PC, PC_IM_PCAdder;
reg [3:0] PCAdderResult_Concat_SL2;
reg [31:0] JumpAddress_in;
                            
//ClkDiv ClkDiv_1(Clk, Rst_ClkDiv, ClkOut); not in use for now
                            
Mux32Bit2To1 PCSrc(PCSrc_MuxJump, PCAdder_Fetch_IFID, PCAdder_JReg_Memory_Fetch, Branch_Fetch);
ProgramCounter PC_1(MuxJump_PC, PC_IM_PCAdder, Rst, Clk);
InstructionMemory IM_1(PC_IM_PCAdder, INSTR_Fetch_IFID); 
PCAdder PCAdder_1(PC_IM_PCAdder, PCAdder_Fetch_IFID);
                            
always@(PCAdder_Fetch_IFID, PC_IM_PCAdder, JumpSL2_Decode_Fetch,PCAdderResult_Concat_SL2)begin//added cuz of syn warning PCAdderResult_Concat_SL2
        PCAdderResult_Concat_SL2 <= PCAdder_Fetch_IFID[31:28];
        JumpAddress_in <= {PCAdderResult_Concat_SL2,JumpSL2_Decode_Fetch[27:0]};
        PCResult_Fetch_Top <= PC_IM_PCAdder;
end
                            
Mux32Bit2To1 MuxJump(MuxJump_PC, PCSrc_MuxJump, JumpAddress_in, JumpControl_Decode_Fetch);
                            
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                            

// Branch_Fetch = Branch_input (1)
// JumpControl_Decode_Fetch = Jump_input (0)
// PCAdder_JReg_Memory_Fetch = Input_Top_PC

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//#FETCH to DECODE#
IF_ID_Reg IF_ID_Reg_1(Clk, Rst, PCAdder_Fetch_IFID, INSTR_Fetch_IFID, PCAdder_IFID_IDEX, INSTR_IFID_Decode);

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//#DECODE STAGE#
//Decode_Stage Decode_Stage_1(Clk, Rst,
//                            INSTR_IFID_Decode, MemReg_WRITE_Decode, RtRd_MEMWB_Decode, RegWrite_MEMWB_Decode, JumpSL2_Decode_Fetch, JumpControl_Decode_Fetch,
//                            RegDst_Decode_IDEX, ALUOp_Decode_IDEX, ALUSrc0_Decode_IDEX, ALUSrc1_Decode_IDEX, MuxStore_Decode_IDEX,
//                            Branch_Decode_IDEX, MemRead_Decode_IDEX, MemWrite_Decode_IDEX,
//                            RegWrite_Decode_IDEX, MemReg_Decode_IDEX, MuxLoad_Decode_IDEX, JRegControl_Decode_IDEX,
//                            RS_Decode_IDEX, AddressRs_Decode_IDEX, RT_Decode_IDEX, AddressRt_Decode_IDEX, RD_Decode_IDEX, SignExt_Decode_IDEX, ZeroExt_Decode_IDEX);

reg [5:0] INSTR_OP, INSTR_5_0;  reg [4:0] INSTR_RS, INSTR_RT, INSTR_RD, INSTR_10_6;
reg [15:0] INSTR_IMMEOFFSET;
reg [31:0] readRsReg, readRtReg; // need 32bit inputs for Read Registers
reg [25:0] Jump_IM_SL2;
always@(Clk, Rst,INSTR_IFID_Decode, MemReg_WRITE_Decode, RtRd_MEMWB_Decode, RegWrite_MEMWB_Decode,INSTR_RD,INSTR_RS,INSTR_RT)begin//added cuz of syn warnings INSTR_RD,INSTR_RS,INSTR_RT
    
    {INSTR_OP, INSTR_RS, INSTR_RT, INSTR_RD, INSTR_10_6, INSTR_5_0} <= INSTR_IFID_Decode;
    INSTR_IMMEOFFSET = INSTR_IFID_Decode[15:0];
    RD_Decode_IDEX = INSTR_RD;
    readRsReg = INSTR_RS;
    readRtReg = INSTR_RT;
    AddressRs_Decode_IDEX = INSTR_RS;
    AddressRt_Decode_IDEX = INSTR_RT;
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
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//#DECODE TO EXECUTION#
ID_EX_Reg ID_EX_Reg_1(RegDst_Decode_IDEX, ALUOp_Decode_IDEX, ALUSrc0_Decode_IDEX, ALUSrc1_Decode_IDEX, MuxStore_Decode_IDEX,
		  	         Branch_Decode_IDEX, MemRead_Decode_IDEX, MemWrite_Decode_IDEX,
		         	 RegWrite_Decode_IDEX, MemReg_Decode_IDEX, MuxLoad_Decode_IDEX,
		          	 RegDst_IDEX_Execution, ALUOp_IDEX_Execution, ALUSrc0_IDEX_Execution, ALUSrc1_IDEX_Execution, MuxStore_IDEX_Execution,
		       	     Branch_IDEX_EXMEM, MemRead_IDEX_EXMEM, MemWrite_IDEX_EXMEM,
		    	     RegWrite_IDEX_EXMEM, MemReg_IDEX_EXMEM, MuxLoad_IDEX_EXMEM,
		    	     PCAdder_IFID_IDEX, PCAdder_IDEX_Execution_EXMEM,
		    	     RS_Decode_IDEX, AddressRs_Decode_IDEX, RT_Decode_IDEX, AddressRt_Decode_IDEX, RD_Decode_IDEX, SignExt_Decode_IDEX, ZeroExt_Decode_IDEX,
		    	     RS_IDEX_Execution, AddressRs_IDEX_Execution, RT_IDEX_Execution, AddressRt_IDEX_Execution, RD_IDEX_Execution, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution,
		    	     JRegControl_Decode_IDEX, JRegControl_IDEX_EXMEM, Clk, Rst);
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//#EXECUTION STAGE#
//Execution_Stage Execution_Stage_1(  Clk, Rst,
//                                    PCAdder_IDEX_Execution_EXMEM, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution,
//                                    RegDst_IDEX_Execution, ALUOp_IDEX_Execution, ALUSrc0_IDEX_Execution, ALUSrc1_IDEX_Execution, MuxStore_IDEX_Execution,
//                                    ALUResult_Execution_EXMEM, ZERO_Execution_EXMEM,
//                                    RS_IDEX_Execution, AddressRs_IDEX_Execution, RT_IDEX_Execution, AddressRt_IDEX_Execution, RD_IDEX_Execution,
//                                    RT_Execution_EXMEM, RtRd_Execution_EXMEM,
//                                    PCAdder_Execution_EXMEM , PullHiReg_output, PullLoReg_output);
reg [15:0] Rt_HW;//switched to 16'b from 32'b cuz of syn warnings 
reg [7:0] Rt_Byte;//switched to 8'b from 32'b cuz of syn warnings
wire [31:0] ALUSrc0_ALU, ALUSrc1_ALU;
wire [31:0] ALU_HI, ALU_LO, HI_ALU, LO_ALU, SEH_StoreData, SEB_StoreData;
wire [31:0] SL2R_Adder;

// Forwarding
wire [1:0] Fwd_A, Fwd_B;
wire [31:0] ALU_inputA, ALU_inputB;

always@(RS_IDEX_Execution, RT_IDEX_Execution)begin
    Rt_HW <= RT_IDEX_Execution [15:0];
    Rt_Byte <= RT_IDEX_Execution [7:0];
end

ShiftLeft2 ShiftLeft2_1(SignExt_IDEX_Execution, SL2R_Adder);
Adder Adder_1(PCAdder_IDEX_Execution_EXMEM, SL2R_Adder, PCAdder_Execution_EXMEM);
Mux32Bit3To1 ALUSrc1(ALUSrc1_ALU, RS_IDEX_Execution, AddressRs_IDEX_Execution, RT_IDEX_Execution, ALUSrc1_IDEX_Execution);
Mux32Bit3To1 ALUSrc0(ALUSrc0_ALU, RT_IDEX_Execution, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution, ALUSrc0_IDEX_Execution);
Mux32Bit3To1 RegDst(RtRd_Execution_EXMEM, AddressRt_IDEX_Execution, RD_IDEX_Execution, 32'd31, RegDst_IDEX_Execution);

Mux32Bit3To1 MuxStore(RT_Execution_EXMEM, RT_IDEX_Execution, SEH_StoreData, SEB_StoreData, MuxStore_IDEX_Execution);
SignExtension SEH_2(Rt_HW, SEH_StoreData);
SignExtByte SEB_2(Rt_Byte, SEB_StoreData);
ALU32Bit ALU32Bit_1(ALUOp_IDEX_Execution, ALU_inputA, ALU_inputB, ALUResult_Execution_EXMEM, ZERO_Execution_EXMEM, HI_ALU, LO_ALU, ALU_HI, ALU_LO);
HiLoReg HiLoReg_1(ALU_HI, ALU_LO, HI_ALU, LO_ALU, Clk, Rst);

// Forwarding
//module FWD(IDEX_Fwd_RegisterRs, IDEX_Fwd_RegisterRd, IDEX_Fwd_RegisterRt, 
//           EXMEM_Fwd_RegWrite, EXMEM_Fwd_RegDst, 
//           MEMWB_Fwd_RegWrite, MEMWB_Fwd_RegDst,
//           Controller_Fwd_OpCode, ALUSrc0, ALUSrc1, 
//           Fwd_A, Fwd_B);
FWD FWD_1(AddressRs_IDEX_Execution, RD_IDEX_Execution, AddressRt_IDEX_Execution, 
          RegWrite_EXMEM_MEMWB, PC2Adder_EXMEM_MEMWB, 
          RegWrite_MEMWB_Decode, RtRd_MEMWB_Decode,
          ALUOp_IDEX_Execution, ALUSrc0_IDEX_Execution, ALUSrc1_IDEX_Execution,
          Fwd_A, Fwd_B);

// Mux32Bit3To1(out, inA, inB, inC, sel);
Mux32Bit3To1 FWD_A(ALU_inputA, ALUSrc1_ALU, ALUResult_EXMEM_Memory_MEMWB, MemReg_WRITE_Decode, Fwd_A);
Mux32Bit3To1 FWD_B(ALU_inputB, ALUSrc0_ALU, ALUResult_EXMEM_Memory_MEMWB, MemReg_WRITE_Decode, Fwd_B);

always@(ALU_HI, ALU_LO)begin
    PullHiReg_output <= ALU_HI; 
    PullLoReg_output <= ALU_LO;
end
                
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//#EXECUTION TO MEMORY#

EX_MEM_Reg EX_MEM_Reg_1(Clk, Rst,
                         Branch_IDEX_EXMEM, MemRead_IDEX_EXMEM, MemWrite_IDEX_EXMEM,
                         RegWrite_IDEX_EXMEM, MemReg_IDEX_EXMEM, MuxLoad_IDEX_EXMEM,
                         Branch_EXMEM_Memory, MemRead_EXMEM_Memory, MemWrite_EXMEM_Memory,
                         RegWrite_EXMEM_MEMWB, MemReg_EXMEM_MEMWB, MuxLoad_EXMEM_Memory,
                         PCAdder_Execution_EXMEM, PCAdder_EXMEM_Memory,
                         PCAdder_IDEX_Execution_EXMEM, PC2Adder_EXMEM_MEMWB,
                         ZERO_Execution_EXMEM, ZERO_EXMEM_Memory,
                         ALUResult_Execution_EXMEM, ALUResult_EXMEM_Memory_MEMWB,
                         RT_Execution_EXMEM, RtRd_Execution_EXMEM,
                         RT_EXMEM_Memory, RtRd_EXMEM_MEMWB, JRegControl_IDEX_EXMEM, JRegControl_EXMEM_Memory,
                         RS_IDEX_Execution, RS_EXMEM_Memory);   

                       
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//#MEMORY STAGE#
//Memory_Stage Memory_Stage_1(Clk,
//                            Branch_EXMEM_Memory, MemRead_EXMEM_Memory, MemWrite_EXMEM_Memory, MuxLoad_EXMEM_Memory,
//                            ALUResult_EXMEM_Memory_MEMWB, JRegControl_EXMEM_Memory, ZERO_EXMEM_Memory, RT_EXMEM_Memory,
//                            PCAdder_EXMEM_Memory, RS_EXMEM_Memory,
//                            Branch_Fetch, PCAdder_JReg_Memory_Fetch,
//                            RT_Memory_MEMWB);

reg [31:0] Load_hw, Load_byte;//both are not in use (where they are being used is commented out)

wire [31:0] DataMemory_MuxLoad, SignExt_LoadData;//SignExt_LoadData not in use
wire [31:0] SEH_MuxLoad, SEB_MuxLoad;

Branch Branch_1(Branch_EXMEM_Memory, ZERO_EXMEM_Memory, Branch_Fetch);

DataMemory DataMemory_1(ALUResult_EXMEM_Memory_MEMWB, RT_EXMEM_Memory, Clk, MemWrite_EXMEM_Memory, MemRead_EXMEM_Memory, DataMemory_MuxLoad);
//         DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData_out); 

//always@(DataMemory_MuxLoad)begin
//    Load_hw <= DataMemory_MuxLoad [15:0];
//    Load_byte <= DataMemory_MuxLoad [7:0];
//end

Mux32Bit3To1 MuxLoad(RT_Memory_MEMWB, DataMemory_MuxLoad, SEH_MuxLoad, SEB_MuxLoad, MuxLoad_EXMEM_Memory);

SignExtByte SEB_1(DataMemory_MuxLoad [7:0], SEB_MuxLoad);

SignExtension SEH_1(DataMemory_MuxLoad [15:0], SEH_MuxLoad);

Mux32Bit2To1 MuxJReg(PCAdder_JReg_Memory_Fetch, PCAdder_EXMEM_Memory, RS_EXMEM_Memory, JRegControl_EXMEM_Memory);            
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//#MEMORY TO WRITE BACK#
MEM_WB_Reg MEM_WB_Reg_1(MemReg_EXMEM_MEMWB, RegWrite_EXMEM_MEMWB,
                           MemReg_MEMWB_WRITE, RegWrite_MEMWB_Decode,
                           RT_Memory_MEMWB, LoadData_MEMWB_WRITE,
                           ALUResult_EXMEM_Memory_MEMWB, ALUResult_MEMWB_WRITE,
                           RtRd_EXMEM_MEMWB, RtRd_MEMWB_Decode,
                           PC2Adder_EXMEM_MEMWB, PC2ndAdder_MEMWB_Write,
                           Clk, Rst);           
            
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//#WRITE BACK STAGE#
//Write_Stage Write_Stage_1( MemReg_MEMWB_WRITE, LoadData_MEMWB_WRITE, PC2ndAdder_MEMWB_Write, ALUResult_MEMWB_WRITE, MemReg_WRITE_Decode);

Mux32Bit3To1 MemReg(MemReg_WRITE_Decode, ALUResult_MEMWB_WRITE, LoadData_MEMWB_WRITE, PC2ndAdder_MEMWB_Write, MemReg_MEMWB_WRITE);//LoadData_MEMWB_WRITE might wanna change to ReadData_MEMWB_WRITE
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

always@(PCResult_Fetch_Top, MemReg_WRITE_Decode, PullHiReg_output, PullLoReg_output)begin
    PC_output <= PCResult_Fetch_Top / 4;
    WriteData_output <= MemReg_WRITE_Decode ; 
    HiReg_output <= PullHiReg_output; 
    LoReg_output <= PullLoReg_output;
end

endmodule
