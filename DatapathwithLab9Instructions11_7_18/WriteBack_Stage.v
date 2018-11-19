`timescale 1ns / 1ps

module Write_Stage( MemReg_in, ReadData_in, PC2ndAdder_in, ALUResult_in, MemRegData_out);

input wire [1:0] MemReg_in; 
input wire [31:0] ReadData_in, PC2ndAdder_in, ALUResult_in;     
output wire [31:0] MemRegData_out;

Mux32Bit3To1 MemReg(MemRegData_out, ALUResult_in, ReadData_in, PC2ndAdder_in, MemReg_in);

endmodule