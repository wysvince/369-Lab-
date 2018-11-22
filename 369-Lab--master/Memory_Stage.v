`timescale 1ns / 1ps

module Memory_Stage(Clk,
                    Branch_EXMEM_Memory, MemRead_EXMEM_Memory, MemWrite_EXMEM_Memory, MuxLoad_EXMEM_Memory,
                    ALUResult_EXMEM_Memory_MEMWB, JRegControl_EXMEM_Memory, ZERO_EXMEM_Memory, RT_EXMEM_Memory,
                    PCAdder_EXMEM_Memory, RS_EXMEM_Memory,
                    Branch_Fetch, PCAdder_JReg_Memory_Fetch,
                    RT_Memory_MEMWB);

input Clk;
input wire Branch_EXMEM_Memory, MemRead_EXMEM_Memory, MemWrite_EXMEM_Memory, JRegControl_EXMEM_Memory, ZERO_EXMEM_Memory;
input wire [1:0] MuxLoad_EXMEM_Memory;
input wire [31:0] PCAdder_EXMEM_Memory,RS_EXMEM_Memory, ALUResult_EXMEM_Memory_MEMWB, RT_EXMEM_Memory;

output wire Branch_Fetch; 

output wire [31:0] RT_Memory_MEMWB, PCAdder_JReg_Memory_Fetch;

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


endmodule
