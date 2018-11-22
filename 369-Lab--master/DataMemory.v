`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - data_memory.v
// Description - 32-Bit wide data memory.
//
// INPUTS:-
// Address: 32-Bit address input port.
// WriteData: 32-Bit input port.
// Clk: 1-Bit Input clock signal.
// MemWrite: 1-Bit control signal for memory write.
// MemRead: 1-Bit control signal for memory read.
//
// OUTPUTS:-
// ReadData: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design the above memory similar to the 'RegisterFile' model in the previous 
// assignment.  Create a 1K memory, for which we need 10 bits.  In order to 
// implement byte addressing, we will use bits Address[11:2] to index the 
// memory location. The 'WriteData' value is written into the address 
// corresponding to Address[11:2] in the positive clock edge if 'MemWrite' 
// signal is 1. 'ReadData' is the value of memory location Address[11:2] if 
// 'MemRea'd is 1, otherwise, it is 0x00000000. The reading of memory is not 
// clocked.
//
// you need to declare a 2d array. in this case we need an array of 1024 (1K)  
// 32-bit elements for the memory.   
// for example,  to declare an array of 256 32-bit elements, declaration is: reg[31:0] memory[0:255]
// if i continue with the same declaration, we need 8 bits to index to one of 256 elements. 
// however , address port for the data memory is 32 bits. from those 32 bits, least significant 2 
// bits help us index to one of the 4 bytes within a single word. therefore we only need bits [9-2] 
// of the "Address" input to index any of the 256 words. 
////////////////////////////////////////////////////////////////////////////////

module DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData_out); 

    input [31:0] Address; 	// Input Address 
    input [31:0] WriteData; // Data that needs to be written into the address 
    input Clk;
    input MemWrite; 		// Control signal for memory write 
    input MemRead; 			// Control signal for memory read 
    integer i = 0;
    output reg[31:0] ReadData_out; // Contents of memory location at Address
   // reg [31:0] temp;
    reg [31:0] Index;
    reg [31:0] memory [0:1023];
    
    initial begin
        for(i = 0; i< 1024;i=i+1)begin
            if(i == 0) begin
                memory[i] <= 32'h02108824;//00000000;  // 1
            end
//            else if(i == 1) begin
//                memory[i] <= 32'h00000001;  //  2
//            end
//            else if(i == 2) begin
//                memory[i] <= 32'h00000002;  //  2
//            end
//            else if(i == 3) begin
//                memory[i] <= 32'h00000003;  //  2
//            end
//            else if(i == 4) begin
//                memory[i] <= 32'h00000004;  //  2
//            end
//            else if(i == 5) begin
//                memory[i] <=-32'h00000001;  //  2
//            end
            else begin
                memory[i] <= 32'd0;
            end
        end
    end
    
	always @(Clk,Address,MemWrite,WriteData,Index) begin// added Address,MemWrite,WriteData,Index cuz of syn warnings
	Index <= Address[9:2] - 1;
        if (MemWrite == 1'b1) begin
            memory[Index] <= WriteData;
        end
    end    
    
      always @(*) begin// switched from * cuz of syn warnings
      Index <= Address[9:2] - 1;
        if (MemRead == 1'b1) begin
           ReadData_out <= memory[Index];
        end
        else if (MemRead == 0) begin
           ReadData_out <= 32'h0; 
        end   
     end    
endmodule

