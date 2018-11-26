`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Vincent Wong 50% & Abdi Tasir 50%
// 
// ECE369A - Computer Architecture
// Laboratory 9
// Module - TopModule_tb.v
///////////////////////////////////////////////////////////////////////////////

module TopModule_tb();

reg Clk, Rst, Rst_ClkDiv;
wire [31:0] PC_output, WriteData_output, HiReg_output, LoReg_output;
          //PC_output <= PCResult_Fetch_Top;
          //WriteData_output <= MemReg_WRITE_Decode ; 
          //HiReg_output <= PullHiReg_output; 
          //LoReg_output <= PullLoReg_output;
//integer i;

TopModule TopModule_1(Clk, Rst, Rst_ClkDiv, PC_output, WriteData_output, HiReg_output, LoReg_output);
    
initial begin
    Clk <= 1'b0;
    forever #10 Clk <= ~Clk;
end  

// Branch_Fetch = Branch_input (1)
// JumpControl_Decode_Fetch = Jump_input (0)
// PCAdder_JReg_Memory_Fetch = Input_Top_PC

initial begin
    Rst <= 1;
    Rst_ClkDiv <= 1;
    #13;
    Rst <= 0;
    #10;
    Rst_ClkDiv <= 0;
    #10;
end


endmodule
