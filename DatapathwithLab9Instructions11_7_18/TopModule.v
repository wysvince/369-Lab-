`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Vincent Wong 50% & Abdi Tasir 50%
// 
// ECE369A - Computer Architecture
// Laboratory 9
// Module - TopModule.v
///////////////////////////////////////////////////////////////////////////////

module TopModule(Clk, Rst, PCResult_Fetch_Top, MemReg_WRITE_Decode, PullHiReg_output, PullLoReg_output);

input Clk, Rst;
output wire [31:0] PullHiReg_output, PullLoReg_output, PCResult_Fetch_Top, MemReg_WRITE_Decode;

wire [31:0] PCAdder_Fetch_IFID, INSTR_Fetch_IFID, JumpSL2_Decode_Fetch, PCAdder_JReg_Memory_Fetch;
wire Branch_Fetch, JumpControl_Decode_Fetch; 
wire [31:0] PCAdder_IFID_IDEX, INSTR_IFID_Decode;

wire [31:0] RtRd_MEMWB_Decode, RS_Decode_IDEX, AddressRs_Decode_IDEX, AddressRt_Decode_IDEX, RT_Decode_IDEX, RD_Decode_IDEX, SignExt_Decode_IDEX, ZeroExt_Decode_IDEX;
wire RegWrite_MEMWB_Decode, MemWrite_Decode_IDEX, Branch_Decode_IDEX, MemRead_Decode_IDEX, RegWrite_Decode_IDEX, JRegControl_Decode_IDEX, JRegControl_IDEX_EXMEM;
wire [5:0] ALUOp_Decode_IDEX;
wire [1:0] RegDst_Decode_IDEX, ALUSrc1_Decode_IDEX, ALUSrc0_Decode_IDEX, MuxStore_Decode_IDEX, MuxLoad_Decode_IDEX;

wire [31:0] PCAdder_IDEX_Execution, RS_IDEX_Execution, RT_IDEX_Execution, AddressRs_IDEX_Execution, AddressRt_IDEX_Execution, RD_IDEX_Execution, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution;
wire Branch_IDEX_EXMEM, JRegControl_EXMEM_Memory, MemWrite_IDEX_EXMEM, MemRead_IDEX_EXMEM, RegWrite_IDEX_EXMEM;
wire [5:0] ALUOp_IDEX_Execution;
wire [1:0] RegDst_IDEX_Execution, ALUSrc0_IDEX_Execution, ALUSrc1_IDEX_Execution, MuxStore_IDEX_Execution, MuxLoad_IDEX_EXMEM;

wire [31:0] PCAdder_IDEX_Execution_EXMEM, RS_EXMEM_Memory, PCAdder_EXMEM_Memory, ALUResult_Execution_EXMEM, RT_Execution_EXMEM, RtRd_Execution_EXMEM, PCAdder_Execution_EXMEM;
wire ZERO_Execution_EXMEM;

wire Branch_EXMEM_Memory, MemRead_EXMEM_Memory, RegWrite_EXMEM_MEMWB, ZERO_EXMEM_Memory;
wire [1:0] MuxLoad_EXMEM_Memory;
wire [31:0] PC2ndAdder_MEMWB_Write, ALUResult_EXMEM_Memory_MEMWB, RT_EXMEM_Memory, RtRd_EXMEM_MEMWB;

wire [31:0] RT_Memory_MEMWB;

wire  [1:0] MemReg_MEMWB_WRITE, MemReg_EXMEM_MEMWB, MemReg_IDEX_EXMEM, MemReg_Decode_IDEX; 
wire [31:0] PC2Adder_EXMEM_MEMWB, LoadData_MEMWB_WRITE, ALUResult_MEMWB_WRITE;

 


Fetch_Stage Fetch_Stage_1( Clk, Rst, Branch_Fetch, JumpControl_Decode_Fetch, PCAdder_JReg_Memory_Fetch, 
                            JumpSL2_Decode_Fetch, PCResult_Fetch_Top,
                            PCAdder_Fetch_IFID, INSTR_Fetch_IFID);
                            
// Branch_Fetch = Branch_input (1)
// JumpControl_Decode_Fetch = Jump_input (0)
// PCAdder_JReg_Memory_Fetch = Input_Top_PC

IF_ID_Reg IF_ID_Reg_1(Clk, Rst, PCAdder_Fetch_IFID, INSTR_Fetch_IFID, PCAdder_IFID_IDEX, INSTR_IFID_Decode);

Decode_Stage Decode_Stage_1(Clk, Rst,
                            INSTR_IFID_Decode, MemReg_WRITE_Decode, RtRd_MEMWB_Decode, RegWrite_MEMWB_Decode, JumpSL2_Decode_Fetch, JumpControl_Decode_Fetch,
                            RegDst_Decode_IDEX, ALUOp_Decode_IDEX, ALUSrc0_Decode_IDEX, ALUSrc1_Decode_IDEX, MuxStore_Decode_IDEX,
                            Branch_Decode_IDEX, MemRead_Decode_IDEX, MemWrite_Decode_IDEX,
                            RegWrite_Decode_IDEX, MemReg_Decode_IDEX, MuxLoad_Decode_IDEX, JRegControl_Decode_IDEX,
                            RS_Decode_IDEX, AddressRs_Decode_IDEX, RT_Decode_IDEX, AddressRt_Decode_IDEX, RD_Decode_IDEX, SignExt_Decode_IDEX, ZeroExt_Decode_IDEX);

ID_EX_Reg ID_EX_Reg_1(RegDst_Decode_IDEX, ALUOp_Decode_IDEX, ALUSrc0_Decode_IDEX, ALUSrc1_Decode_IDEX, MuxStore_Decode_IDEX,
		  	         Branch_Decode_IDEX, MemRead_Decode_IDEX, MemWrite_Decode_IDEX,
		         	 RegWrite_Decode_IDEX, MemReg_Decode_IDEX, MuxLoad_Decode_IDEX,
		          	 RegDst_IDEX_Execution, ALUOp_IDEX_Execution, ALUSrc0_IDEX_Execution, ALUSrc1_IDEX_Execution, MuxStore_IDEX_Execution,
		       	     Branch_IDEX_EXMEM, MemRead_IDEX_EXMEM, MemWrite_IDEX_EXMEM,
		    	     RegWrite_IDEX_EXMEM, MemReg_IDEX_EXMEM, MuxLoad_IDEX_EXMEM,
		    	     PCAdder_IFID_IDEX, PCAdder_IDEX_Execution_EXMEM,
		    	     RS_Decode_IDEX, AddressRs_Decode_IDEX, RT_Decode_IDEX, AddressRt_Decode_IDEX, RD_Decode_IDEX, SignExt_Decode_IDEX, ZeroExt_Decode_IDEX,
		    	     RS_IDEX_Execution, AddressRs_IDEX_Execution, RT_IDEX_Execution, AddressRt_IDEX_Execution, RD_IDEX_Execution, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution,
		    	     JRegControl_Decode_IDEX, JRegControl_IDEX_EXMEM, Clk, Rst);


Execution_Stage Execution_Stage_1(  Clk, Rst,
                                    PCAdder_IDEX_Execution_EXMEM, SignExt_IDEX_Execution, ZeroExt_IDEX_Execution,
                                    RegDst_IDEX_Execution, ALUOp_IDEX_Execution, ALUSrc0_IDEX_Execution, ALUSrc1_IDEX_Execution, MuxStore_IDEX_Execution,
                                    ALUResult_Execution_EXMEM, ZERO_Execution_EXMEM,
                                    RS_IDEX_Execution, AddressRs_IDEX_Execution, RT_IDEX_Execution, AddressRt_IDEX_Execution, RD_IDEX_Execution,
                                    RT_Execution_EXMEM, RtRd_Execution_EXMEM,
                                    PCAdder_Execution_EXMEM , PullHiReg_output, PullLoReg_output);
                
EX_MEM_Reg EX_MEM_Reg_1(Clk, Rst,
                         Branch_IDEX_EXMEM, MemRead_IDEX_EXMEM, MemWrite_IDEX_EXMEM,
                         RegWrite_IDEX_EXMEM, MemReg_IDEX_EXMEM, MuxLoad_IDEX_EXMEM,
                         Branch_EXMEM_Memory, MemRead_EXMEM_Memory, MemWrite_EXMEM_Memory,
                         RegWrite_EXMEM_MEMWB, MemReg_EXMEM_MEMWB, MuxLoad_EXMEM_Memory,
                         PCAdder_Execution_EXMEM, PCAdder_EXMEM_Memory,
                         PCAdder_IDEX_Execution_EXMEM, PC2Adder_EXMEM_MEMWB,
                         ZERO_Execution_EXMEM, ZERO_EXMEM_Memory,
                         ALUResult_Execution_EXMEM, ALUResult_EXMEM_Memory_MEMWB,
                         RT_Execution_EXMEM, RtRd_Execution_EXMEM,
                         RT_EXMEM_Memory, RtRd_EXMEM_MEMWB, JRegControl_IDEX_EXMEM, JRegControl_EXMEM_Memory,
                         RS_IDEX_Execution, RS_EXMEM_Memory);   

                       
Memory_Stage Memory_Stage_1(Clk,
                            Branch_EXMEM_Memory, MemRead_EXMEM_Memory, MemWrite_EXMEM_Memory, MuxLoad_EXMEM_Memory,
                            ALUResult_EXMEM_Memory_MEMWB, JRegControl_EXMEM_Memory, ZERO_EXMEM_Memory, RT_EXMEM_Memory,
                            PCAdder_EXMEM_Memory, RS_EXMEM_Memory,
                            Branch_Fetch, PCAdder_JReg_Memory_Fetch,
                            RT_Memory_MEMWB);
            
MEM_WB_Reg MEM_WB_Reg_1(MemReg_EXMEM_MEMWB, RegWrite_EXMEM_MEMWB,
                           MemReg_MEMWB_WRITE, RegWrite_MEMWB_Decode,
                           RT_Memory_MEMWB, LoadData_MEMWB_WRITE,
                           ALUResult_EXMEM_Memory_MEMWB, ALUResult_MEMWB_WRITE,
                           RtRd_EXMEM_MEMWB, RtRd_MEMWB_Decode,
                           PC2Adder_EXMEM_MEMWB, PC2ndAdder_MEMWB_Write,
                           Clk, Rst);           
            
Write_Stage Write_Stage_1( MemReg_MEMWB_WRITE, LoadData_MEMWB_WRITE, PC2ndAdder_MEMWB_Write, ALUResult_MEMWB_WRITE, MemReg_WRITE_Decode);

endmodule
