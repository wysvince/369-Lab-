`timescale 1ns / 1ps

module Execution_Stage(Clk, Rst,
                        PCAdder_in, SignExt_in, ZeroExt_in,
                        RegDst_in, ALUOp_in, ALUSrc0_in, ALUSrc1_in, MuxStore_in,               // EX
                        ALUResult_out, Zero_out,                              // EX
                        Rs_in, AddressRs_in, Rt_in, AddressRt_in, Rd_in,
                        Rt_out, RtRd_out,
                        PCAdder_out, PullHiReg_output, PullLoReg_output );

input Clk, Rst;
output reg [31:0] PullHiReg_output, PullLoReg_output;

input wire [31:0] PCAdder_in, SignExt_in, ZeroExt_in;
input wire [1:0] RegDst_in, ALUSrc1_in, ALUSrc0_in, MuxStore_in;
input wire [5:0] ALUOp_in;
output wire Zero_out; output wire [31:0] ALUResult_out;                     // EX                           // WB
output wire [31:0] Rt_out, RtRd_out, PCAdder_out;

input wire [31:0] Rs_in, AddressRs_in, Rt_in, AddressRt_in, Rd_in;
reg [15:0] Rt_HW;
reg [7:0] Rt_Byte;

wire [31:0] ALUSrc0_ALU, ALUSrc1_ALU;
wire [31:0] ALU_HI, ALU_LO, HI_ALU, LO_ALU, SEH_StoreData, SEB_StoreData;

always@(Rs_in, Rt_in)begin
    Rt_HW <= Rt_in [15:0];
    Rt_Byte <= Rt_in [7:0];
end

wire [31:0] SL2R_Adder;

ShiftLeft2 ShiftLeft2_1(SignExt_in, SL2R_Adder);

Adder Adder_1(PCAdder_in, SL2R_Adder, PCAdder_out);

Mux32Bit3To1 ALUSrc1(ALUSrc1_ALU, Rs_in, AddressRs_in, Rt_in, ALUSrc1_in);

Mux32Bit3To1 ALUSrc0(ALUSrc0_ALU, Rt_in, SignExt_in, ZeroExt_in, ALUSrc0_in);

Mux32Bit3To1 RegDst(RtRd_out, AddressRt_in, Rd_in, 32'd31, RegDst_in);



Mux32Bit3To1 MuxStore(Rt_out, Rt_in, SEH_StoreData, SEB_StoreData, MuxStore_in);

SignExtension SEH_2(Rt_HW, SEH_StoreData);

SignExtByte SEB_2(Rt_Byte, SEB_StoreData);


ALU32Bit ALU32Bit_1(ALUOp_in, ALUSrc1_ALU, ALUSrc0_ALU, ALUResult_out, Zero_out, HI_ALU, LO_ALU, ALU_HI, ALU_LO);

HiLoReg HiLoReg_1(ALU_HI, ALU_LO, HI_ALU, LO_ALU, Clk, Rst);

always@(ALU_HI, ALU_LO)begin
    PullHiReg_output <= ALU_HI; 
    PullLoReg_output <= ALU_LO;
end
endmodule