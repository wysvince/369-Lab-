`timescale 1ns / 1ps

module Execution_Stage(Clk, Rst,
                        PCAdder_IDEX_Execution_EXMEM, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution,
                        RegDst_IDEX_Execution, ALUOp_IDEX_Execution, ALUSrc0_IDEX_Execution, ALUSrc1_IDEX_Execution, MuxStore_IDEX_Execution,               // EX
                        ALUResult_Execution_EXMEM, ZERO_Execution_EXMEM,                              // EX
                        RS_IDEX_Execution, AddressRs_IDEX_Execution, RT_IDEX_Execution, AddressRt_IDEX_Execution, RD_IDEX_Execution,
                        RT_Execution_EXMEM, RtRd_Execution_EXMEM,
                        PCAdder_Execution_EXMEM, PullHiReg_output, PullLoReg_output );

input Clk, Rst;
output reg [31:0] PullHiReg_output, PullLoReg_output;

input wire [31:0] PCAdder_IDEX_Execution_EXMEM, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution;
input wire [1:0] RegDst_IDEX_Execution, ALUSrc1_IDEX_Execution, ALUSrc0_IDEX_Execution, MuxStore_IDEX_Execution;
input wire [5:0] ALUOp_IDEX_Execution;
output wire ZERO_Execution_EXMEM; output wire [31:0] ALUResult_Execution_EXMEM;                     // EX                           // WB
output wire [31:0] RT_Execution_EXMEM, RtRd_Execution_EXMEM, PCAdder_Execution_EXMEM;

input wire [31:0] RS_IDEX_Execution, AddressRs_IDEX_Execution, RT_IDEX_Execution, AddressRt_IDEX_Execution, RD_IDEX_Execution;
reg [31:0] Rt_HW, Rt_Byte;

wire [31:0] ALUSrc0_ALU, ALUSrc1_ALU;
wire [31:0] ALU_HI, ALU_LO, HI_ALU, LO_ALU, SEH_StoreData, SEB_StoreData;

always@(RS_IDEX_Execution, RT_IDEX_Execution)begin
    Rt_HW <= RT_IDEX_Execution [15:0];
    Rt_Byte <= RT_IDEX_Execution [7:0];
end

wire [31:0] SL2R_Adder;

ShiftLeft2 ShiftLeft2_1(SignExt_IDEX_Execution, SL2R_Adder);

Adder Adder_1(PCAdder_IDEX_Execution_EXMEM, SL2R_Adder, PCAdder_Execution_EXMEM);

Mux32Bit3To1 ALUSrc1(ALUSrc1_ALU, RS_IDEX_Execution, AddressRs_IDEX_Execution, RT_IDEX_Execution, ALUSrc1_IDEX_Execution);

Mux32Bit3To1 ALUSrc0(ALUSrc0_ALU, RT_IDEX_Execution, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution, ALUSrc0_IDEX_Execution);

Mux32Bit3To1 RegDst(RtRd_Execution_EXMEM, AddressRt_IDEX_Execution, RD_IDEX_Execution, 32'd31, RegDst_IDEX_Execution);



Mux32Bit3To1 MuxStore(RT_Execution_EXMEM, RT_IDEX_Execution, SEH_StoreData, SEB_StoreData, MuxStore_IDEX_Execution);

SignExtension SEH_2(Rt_HW, SEH_StoreData);

SignExtByte SEB_2(Rt_Byte, SEB_StoreData);


ALU32Bit ALU32Bit_1(ALUOp_IDEX_Execution, ALUSrc1_ALU, ALUSrc0_ALU, ALUResult_Execution_EXMEM, ZERO_Execution_EXMEM, HI_ALU, LO_ALU, ALU_HI, ALU_LO);

HiLoReg HiLoReg_1(ALU_HI, ALU_LO, HI_ALU, LO_ALU, Clk, Rst);

always@(ALU_HI, ALU_LO)begin
    PullHiReg_output <= ALU_HI; 
    PullLoReg_output <= ALU_LO;
end
endmodule