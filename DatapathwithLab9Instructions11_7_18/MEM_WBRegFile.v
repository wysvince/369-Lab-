`timescale 1ns / 1ps

module MEM_WB_Reg(MemReg_in, RegWrite_in, // WB
                 MemReg_out, RegWrite_out, // WB
                 ReadData_in, ReadData_out, // Data memory
                 ALUResult_in, ALUResult_out, // ALU
                 PC2ndAdder_in, RtRd_out, RtRd_in, PC2ndAdder_out,
                 Clk, Rst);

	
	input Clk, Rst;	

	// WB
	input RegWrite_in;
	input [1:0] MemReg_in;
	reg ReadRegWrite;
	reg [1:0] ReadMemReg;
	output reg RegWrite_out;
	output reg [1:0] MemReg_out;

	input [31:0] ReadData_in, ALUResult_in, PC2ndAdder_in, RtRd_in;
	reg [31:0] ReadData, ReadALUResult, ReadPC2ndAdder, ReadRtRd;
	output reg [31:0] ReadData_out, ALUResult_out, PC2ndAdder_out, RtRd_out;
	
//    always@(Rst) begin
//        if(Rst==1)begin
//            MemReg_out <= 0;
//            RegWrite_out <= 0;
//            ReadData_out <= 0;
//            ALUResult_out <= 0;
//            RtRd_out <= 0; 
//        end 
//    end

//    always @(negedge Clk) begin
//    	ReadMemReg <= MemReg_in;
//    	ReadRegWrite <= RegWrite_in;
//    	ReadData <= ReadData_in;
//    	ReadALUResult <= ALUResult_in;
//    	ReadPC2ndAdder <= PC2ndAdder_in;
//    	ReadRtRd <= RtRd_in;
//    end
	
	always@(posedge Clk) begin
	if(Rst==1)begin
        MemReg_out <= 0;
        RegWrite_out <= 0;
        ReadData_out <= 0;
        ALUResult_out <= 0;
        PC2ndAdder_out <= 0;
        RtRd_out <= 0; 
    end 
    
    else begin
        MemReg_out <= MemReg_in;
        RegWrite_out <= RegWrite_in;
        ReadData_out <= ReadData_in;
        ALUResult_out <= ALUResult_in;
        PC2ndAdder_out <= PC2ndAdder_in;
        RtRd_out <= RtRd_in;
	end
	end

endmodule