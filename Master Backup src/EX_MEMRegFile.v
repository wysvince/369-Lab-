`timescale 1ns / 1ps

module EX_MEM_Reg(Clk, Rst,
                     Branch_in, MemRead_in, MemWrite_in,	// M
                     RegWrite_in, MemReg_in, MuxLoad_in,                // WB
                     Branch_out, MemRead_out, MemWrite_out,	// M
                     RegWrite_out, MemReg_out, MuxLoad_out,              // WB
                     PCAdder_in, PCAdder_out,
                     PC2ndAdder_in, RtRd_out,
                     Zero_in, Zero_out,
                     ALUResult_in, ALUResult_out,
                     Rt_in, RtRd_in,
                     Rt_out, PC2ndAdder_out, JRegControl_in, JRegControl_out,
                     Rs_in, Rs_out);

	
	input Clk, Rst;	

	// M
	input Branch_in, MemRead_in, MemWrite_in, JRegControl_in;
    reg ReadBranch, ReadMemRead, ReadMemWrite, ReadJRegControl;
	output reg Branch_out, MemRead_out, MemWrite_out, JRegControl_out;
	
	// WB
	input RegWrite_in; input [1:0] MemReg_in, MuxLoad_in;
    reg ReadRegWrite; reg [1:0] ReadMemReg, ReadMuxLoad;
	output reg RegWrite_out; output reg [1:0] MemReg_out, MuxLoad_out;

	input [31:0] PCAdder_in, PC2ndAdder_in, ALUResult_in, Rt_in, RtRd_in, Rs_in; 
    reg [31:0] ReadPCAdder, ReadPC2ndAdder, ReadALUResult, ReadRt, ReadRtRd;
	output reg [31:0] PCAdder_out, PC2ndAdder_out, ALUResult_out, Rt_out, RtRd_out, Rs_out;
	input Zero_in;
    reg ReadZero;
	output reg Zero_out;

//    always@(negedge Clk)begin
//        ReadBranch <= Branch_in; 
//        ReadMemRead <= MemRead_in; 
//        ReadMemWrite <= MemWrite_in;
//        ReadRegWrite <= RegWrite_in;
//        ReadMemReg <= MemReg_in;
//        ReadMuxLoad <= MuxLoad_in;
//        ReadPCAdder <= PCAdder_in;
//        ReadPC2ndAdder <= PC2ndAdder_in;
//        ReadALUResult <= ALUResult_in;
//        ReadRt <= Rt_in;
//        ReadRtRd <= RtRd_in;
//        ReadZero <= Zero_in;
//        ReadJRegControl <= JRegControl_in;
//    end
    
	always@(posedge Clk) begin
	   if(Rst == 1) begin
            Branch_out <= 0;
            MemRead_out <= 0;
            MemWrite_out <= 0;
            MemReg_out <= 0;
            MuxLoad_out <= 0;
            PCAdder_out <= 0;
            PC2ndAdder_out <= 0;
            ALUResult_out <= 0;
            Rt_out <= 0;
            RtRd_out <= 0;
            Zero_out <= 0;
            JRegControl_out <= 0;
        end
	    
	    else begin
            Branch_out <= Branch_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            RegWrite_out <= RegWrite_in;
            MemReg_out <= MemReg_in;
            MuxLoad_out <= MuxLoad_in;
            PCAdder_out <= PCAdder_in;
            PC2ndAdder_out <= PC2ndAdder_in;
            ALUResult_out <= ALUResult_in;
            Rt_out <= Rt_in;
            Rs_out <= Rs_in;
            RtRd_out <= RtRd_in;
            Zero_out <= Zero_in;
            JRegControl_out <= JRegControl_in;
        end
	end

endmodule