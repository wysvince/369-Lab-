`timescale 1ns / 1ps

module IF_ID_Reg( Clk, Rst, PCAdder_in, Instruction_in, PCAdder_out, Instruction_out);

	input Clk, Rst;
	input [31:0] PCAdder_in, Instruction_in;
	reg [31:0] readPCAdder, readInstruction;
	output reg [31:0]  PCAdder_out, Instruction_out;
	
//	always@(Rst)begin
//	   if(Rst == 1)begin
//	       readPCAdder <= 0;
//	       readInstruction <= 0;
//	   end
//	end
	
	 //get inputs at negative edge Clk
   always@(negedge Clk) begin 
      readPCAdder <= PCAdder_in;
      readInstruction <= Instruction_in;
   end
    
    // set outputs at positive edge Clk
	always@(posedge Clk) begin
	   if(Rst == 1)begin
	   PCAdder_out <= 0;
	   Instruction_out <= 0;
	   end
	   
	   else begin
	    PCAdder_out <= readPCAdder;
	    Instruction_out <= readInstruction;
	   end
	end

endmodule