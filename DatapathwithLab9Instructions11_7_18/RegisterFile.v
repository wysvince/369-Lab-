`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
//
//
// Student(s) Name and Last Name: FILL IN YOUR INFO HERE!
//
//
// Module - register_file.v
// Description - Implements a register file with 32 32-Bit wide registers.
//
// 
// INPUTS:-
// ReadRegister1: 5-Bit address to select a register to be read through 32-Bit 
//                output port 'ReadRegister1'.
// ReadRegister2: 5-Bit address to select a register to be read through 32-Bit 
//                output port 'ReadRegister2'.
// WriteRegister: 5-Bit address to select a register to be written through 32-Bit
//                input port 'WriteRegister'.
// WriteData: 32-Bit write input port.
// RegWrite: 1-Bit control input signal.
//
// OUTPUTS:-
// ReadData1: 32-Bit registered output. 
// ReadData2: 32-Bit registered output. 
//
// FUNCTIONALITY:-
// 'ReadRegister1' and 'ReadRegister2' are two 5-bit addresses to read two 
// registers simultaneously. The two 32-bit data sets are available on ports 
// 'ReadData1' and 'ReadData2', respectively. 'ReadData1' and 'ReadData2' are 
// registered outputs (output of register file is written into these registers 
// at the falling edge of the clock). You can view it as if outputs of registers
// specified by ReadRegister1 and ReadRegister2 are written into output 
// registers ReadData1 and ReadData2 at the falling edge of the clock. 
//
// 'RegWrite' signal is high during the rising edge of the clock if the input 
// data is to be written into the register file. The contents of the register 
// specified by address 'WriteRegister' in the register file are modified at the 
// rising edge of the clock if 'RegWrite' signal is high. The D-flip flops in 
// the register file are positive-edge (rising-edge) triggered. (You have to use 
// this information to generate the write-clock properly.) 
//
// NOTE:-
// We will design the register file such that the contents of registers do not 
// change for a pre-specified time before the falling edge of the clock arrives 
// to allow for data multiplexing and setup time.
////////////////////////////////////////////////////////////////////////////////

module RegisterFile(ReadReg1, ReadReg2, WriteReg, WriteData, RegWrite, Clk, Rst, ReadData1, ReadData2);

	
	input[31:0] ReadReg1, ReadReg2;
	output reg [31:0] ReadData1, ReadData2;
	input [31:0] WriteReg;
	input [31:0] WriteData;
	input Clk, Rst, RegWrite; 
	reg [31:0] Register [0:31];
	integer i;
	
    initial begin
        for(i = 0; i < 32; i = i + 1)begin
            if (i==0) begin
                Register[0] <= 0;
            end
            else begin//Register[i] <= 32'h0;
                Register[i] <= 32'd0;
            end
        end
    end
	
	
//	// reads content of register address ReadReg1 & ReadReg2 at negative edge Clk
//	always@(negedge Clk) begin
////	   if(Rst == 1) begin
////            ReadData1 <= 0;
////            ReadData2 <= 0;
////            for(i = 1; i < 32; i = i + 1)begin
////                Register[i] <= 32'h0;
////            end
////        end
////        else begin
//           ReadData1 <= Register[ReadReg1];
//           ReadData2 <= Register[ReadReg2];
////       end
//    end
       
//    // writes data to register address ReadReg1 & ReadReg2 at positive edge Clk
//    always@(posedge Clk) begin
//        if(RegWrite == 1) begin
//            Register[WriteReg] <= WriteData;
//       end
//    end
    
    always @(negedge Clk or posedge Clk) begin
        if(Rst)begin
            for(i = 0; i < 32; i = i + 1)begin
                if (i==0) begin
                   Register[0] <= 0;
                end
                else begin//Register[i] <= 32'h0;
                   Register[i] <= 32'd0;
                end
            end
        end
        else begin
            if (Clk == 0) begin
                ReadData1 <= Register[ReadReg1];
                ReadData2 <= Register[ReadReg2];
            end
            else if(Clk == 1) begin
                if(RegWrite == 1) begin
                        Register[WriteReg] <= WriteData;
                end
            end
        end
        
    end

endmodule