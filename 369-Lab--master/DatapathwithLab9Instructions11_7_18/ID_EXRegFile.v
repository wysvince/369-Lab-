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
	output reg [5:0] ALUOp_out; output reg [1:0] RegDst_out, ALUSrc1_out, ALUSrc0_out, MuxStore_out;
	
	// M
	input Branch_in, MemWrite_in, MemRead_in, JRegControl_in; 
	output reg Branch_out, MemWrite_out, MemRead_out, JRegControl_out; 
	
	// WB
	input RegWrite_in; input [1:0] MemReg_in, MuxLoad_in;
	output reg RegWrite_out; output reg [1:0] MemReg_out, MuxLoad_out;

	input [31:0] PCAdder_in, Rs_in, Rt_in, SignExt_in, ZeroExt_in, AddressRs_in, AddressRt_in, Rd_in;
	output reg [31:0] PCAdder_out, Rs_out, Rt_out, AddressRs_out, AddressRt_out, Rd_out, SignExt_out, ZeroExt_out;
	

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
            RegDst_out <=  RegDst_in;
            ALUOp_out <=  ALUOp_in;
            ALUSrc0_out <=  ALUSrc0_in;
            ALUSrc1_out <=  ALUSrc1_in;
            MuxStore_out <=  MuxStore_in;
            Branch_out <=  Branch_in;
            MemRead_out <=  MemRead_in;
            MemWrite_out <=  MemWrite_in;
            RegWrite_out <=  RegWrite_in;
            MemReg_out <=  MemReg_in;
            MuxLoad_out <=  MuxLoad_in;
            PCAdder_out <=  PCAdder_in;
            Rs_out <=  Rs_in;
            Rt_out <=  Rt_in;
            AddressRs_out <=  AddressRs_in;
            AddressRt_out <=  AddressRt_in;
            SignExt_out <=  SignExt_in;
            ZeroExt_out <=  ZeroExt_in;
            Rd_out <= Rd_in;
            JRegControl_out <= JRegControl_in; 
        end
	end

endmodule