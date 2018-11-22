`timescale 1ns / 1ps

module Write_Stage( MemReg_MEMWB_WRITE, LoadData_MEMWB_WRITE, PC2ndAdder_MEMWB_Write, ALUResult_MEMWB_WRITE, MemReg_WRITE_Decode);
Writ Write_Stage_1( MemReg_MEMWB_WRITE, LoadData_MEMWB_WRITE, PC2ndAdder_MEMWB_Write, ALUResult_MEMWB_WRITE, MemReg_WRITE_Decode);

input wire [1:0] MemReg_MEMWB_WRITE; 
input wire [31:0] LoadData_MEMWB_WRITE, PC2ndAdder_MEMWB_Write, ALUResult_MEMWB_WRITE;     
output wire [31:0] MemReg_WRITE_Decode;

Mux32Bit3To1 MemReg(MemReg_WRITE_Decode, ALUResult_MEMWB_WRITE, LoadData_MEMWB_WRITE, PC2ndAdder_MEMWB_Write, MemReg_MEMWB_WRITE);//LoadData_MEMWB_WRITE might wanna change to ReadData_MEMWB_WRITE

endmodule