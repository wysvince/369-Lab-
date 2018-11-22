`timescale 1ns / 1ps

module Memory_Stage(Clk,
                    Branch_in, MemRead_in, MemWrite_in, MuxLoad_in,
                    ALUResult_in, JReg_in, Zero_in, Rt_in,
                    PCAdder_in, ReadRS_in,
                    Branch_out, PCAdderJReg_out,
                    Rt_out);

input Clk;
input wire Branch_in, MemWrite_in, MemRead_in, JReg_in, Zero_in;
input wire [1:0] MuxLoad_in;
input [31:0] PCAdder_in,ReadRS_in, ALUResult_in, Rt_in;

output wire Branch_out; 

output wire [31:0] Rt_out, PCAdderJReg_out;

reg [31:0] Load_hw, Load_byte;

wire [31:0] DataMemory_MuxLoad, SignExt_LoadData;
wire [31:0] SEH_MuxLoad, SEB_MuxLoad;

Branch Branch_1(Branch_in, Zero_in, Branch_out);

DataMemory DataMemory_1(ALUResult_in, Rt_in, Clk, MemWrite_in, MemRead_in, DataMemory_MuxLoad);
//         DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData_out); 

//always@(DataMemory_MuxLoad)begin
//    Load_hw <= DataMemory_MuxLoad [15:0];
//    Load_byte <= DataMemory_MuxLoad [7:0];
//end

Mux32Bit3To1 MuxLoad(Rt_out, DataMemory_MuxLoad, SEH_MuxLoad, SEB_MuxLoad, MuxLoad_in);

SignExtByte SEB_1(DataMemory_MuxLoad [7:0], SEB_MuxLoad);

SignExtension SEH_1(DataMemory_MuxLoad [15:0], SEH_MuxLoad);

Mux32Bit2To1 MuxJReg(PCAdderJReg_out, PCAdder_in, ReadRS_in, JReg_in);


endmodule
