`timescale 1ns / 1ps

module ID_EX_Reg(    RegDst_in, ALUOp_in, ALUSrc0_in, ALUSrc1_in, MuxStore_in,            // EX
		  	         Branch_in, MemRead_in, MemWrite_in,	                              // M
		         	 RegWrite_in, MemReg_in, MuxLoad_in,                                 // WB
		          	 RegDst_out, ALUOp_out, ALUSrc0_out, ALUSrc1_out, MuxStore_out,       // EX
		       	     Branch_out, MemRead_out, MemWrite_out,	                              // M
		    	     RegWrite_out, MemReg_out, MuxLoad_out,                              // WB
		    	     PCAdder_in, PCAdder_out,
		    	     Rs_in, AddressRs_in, Rt_in, AddressRt_in, Rd_in, SignExt_in, ZeroExt_in,
		    	     Rs_out, AddressRs_out, Rt_out,AddressRt_out, Rd_out, SignExt_out, ZeroExt_out,
		    	     JRegControl_in, JRegControl_out, Clk, Rst);

	
	input Clk, Rst;	

	// EX
	input [5:0] ALUOp_in; input [1:0] RegDst_in, ALUSrc1_in, ALUSrc0_in, MuxStore_in;
	reg [ 5:0] ReadALUOp; reg [1:0] ReadRegDst, ReadALUSrc1, ReadALUSrc0, ReadMuxStore;
	output reg [5:0] ALUOp_out; output reg [1:0] RegDst_out, ALUSrc1_out, ALUSrc0_out, MuxStore_out;
	
	// M
	input Branch_in, MemRead_in, MemWrite_in, JRegControl_in;
	reg ReadBranch, ReadMemRead, ReadMemWrite, ReadJRegControl;
	output reg Branch_out, MemRead_out, MemWrite_out, JRegControl_out;
	
	// WB
	input RegWrite_in; input [1:0] MemReg_in, MuxLoad_in;
	reg ReadRegWrite; reg [1:0] ReadMemReg, ReadMuxLoad;
	output reg RegWrite_out; output reg [1:0] MemReg_out, MuxLoad_out;

	input [31:0] PCAdder_in, Rs_in, Rt_in, SignExt_in, ZeroExt_in, AddressRs_in, AddressRt_in, Rd_in;
	reg [31:0] ReadPCAdder, ReadRs, ReadRt, ReadAddressRs, ReadAddressRt, ReadSignExt, ReadZeroExt, ReadRd;
	output reg [31:0] PCAdder_out, Rs_out, Rt_out, AddressRs_out, AddressRt_out, Rd_out, SignExt_out, ZeroExt_out;
	
//	always@(Rst)begin
//	   if(Rst == 1)begin
//	       ReadRegDst <= 0;
//           ReadALUOp <= 0;
//           ReadALUSrc0 <= 0;
//           ReadALUSrc1 <= 0;
//           ReadMuxStore <= 0;
//           ReadBranch <= 0;
//           ReadMemRead <= 0;
//           ReadMemWrite <= 0;
//           ReadRegWrite <= 0;
//           ReadMemReg <= 0;
//           ReadMuxLoad <= 0;
//           ReadPCAdder <= 0;
//           ReadRs <= 0;
//           ReadRt <= 0;
//           ReadAddressRs <= 0;
//           ReadAddressRt <= 0;
//           ReadSignExt <= 0;
//           ReadZeroExt <= 0;
//           ReadRd <= 0;
//	   end
//	end

//	always@(negedge Clk)begin
//		ReadRegDst <= RegDst_in;
//		ReadALUOp <= ALUOp_in;
//		ReadALUSrc0 <= ALUSrc0_in;
//		ReadALUSrc1 <= ALUSrc1_in;
//		ReadMuxStore <= MuxStore_in;
//		ReadBranch <= Branch_in;
//		ReadMemRead <= MemRead_in;
//		ReadMemWrite <= MemWrite_in;
//		ReadRegWrite <= RegWrite_in;
//		ReadMemReg <= MemReg_in;
//		ReadMuxLoad <= MuxLoad_in;
//		ReadPCAdder <= PCAdder_in;
//		ReadRs <= Rs_in;
//		ReadRt <= Rt_in;
//		ReadAddressRs <= AddressRs_in;
//		ReadAddressRt <= AddressRt_in;
//		ReadSignExt <= SignExt_in;
//		ReadZeroExt <= ZeroExt_in;
//		ReadRd <= Rd_in;
//		ReadJRegControl <= JRegControl_in;
//	end

	always@(posedge Clk) begin
        if(Rst == 1) begin
            RegDst_out <= 0;
            ALUOp_out <= 0;
            ALUSrc0_out <= 0;
            ALUSrc1_out <= 0;
            MuxStore_out <= 0;
            Branch_out <= 0;
            MemRead_out <= 0;
            MemWrite_out <= 0;
            RegWrite_out <= 0;
            MemReg_out <= 0;
            MuxLoad_out <= 0;
            PCAdder_out <= 0;
            Rs_out <= 0;
            Rt_out <= 0;
            AddressRs_out <= 0;
            AddressRt_out <= 0;
            SignExt_out <= 0;
            ZeroExt_out <= 0;
            Rd_out <= 0;
            JRegControl_out <= 0;
        end
        
        else begin
            RegDst_out =  RegDst_in;
            ALUOp_out =  ALUOp_in;
            ALUSrc0_out =  ALUSrc0_in;
            ALUSrc1_out =  ALUSrc1_in;
            MuxStore_out =  MuxStore_in;
            Branch_out =  Branch_in;
            MemRead_out =  MemRead_in;
            MemWrite_out =  MemWrite_in;
            RegWrite_out =  RegWrite_in;
            MemReg_out =  MemReg_in;
            MuxLoad_out =  MuxLoad_in;
            PCAdder_out =  PCAdder_in;
            Rs_out =  Rs_in;
            Rt_out =  Rt_in;
            AddressRs_out =  AddressRs_in;
            AddressRt_out =  AddressRt_in;
            SignExt_out =  SignExt_in;
            ZeroExt_out =  ZeroExt_in;
            Rd_out = Rd_in;
            JRegControl_out = JRegControl_in; 
        end
    end
endmodule