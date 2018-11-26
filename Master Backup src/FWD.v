`timescale 1ns / 1ps

module FWD(IDEX_Fwd_RegisterRs, IDEX_Fwd_RegisterRd, IDEX_Fwd_RegisterRt, 
           EXMEM_Fwd_RegWrite, EXMEM_Fwd_RegDst, 
           MEMWB_Fwd_RegWrite, MEMWB_Fwd_RegDst,
           Controller_Fwd_OpCode, ALUSrc0, ALUSrc1, 
           Fwd_A, Fwd_B);

input [31:0] IDEX_Fwd_RegisterRs, IDEX_Fwd_RegisterRd, IDEX_Fwd_RegisterRt;
input EXMEM_Fwd_RegWrite, MEMWB_Fwd_RegWrite;
input [5:0] Controller_Fwd_OpCode;
input [1:0] ALUSrc0, ALUSrc1;
input [31:0] EXMEM_Fwd_RegDst, MEMWB_Fwd_RegDst;

output reg [1:0] Fwd_A, Fwd_B;

always@(*)begin
    Fwd_A <= 2'bxx;
    Fwd_B <= 2'bxx;
    
    // check types of operation that requires Forwarding
//    if(Controller_Fwd_OpCode == 0)begin
    
//    end
    
    //Forwarding from Memory Stage to Execution Stage
    if(EXMEM_Fwd_RegWrite == 1 && ALUSrc1 == 0 && IDEX_Fwd_RegisterRs == EXMEM_Fwd_RegDst)begin
        Fwd_A <= 1; 
        Fwd_B <= 0;
    end
    else if(EXMEM_Fwd_RegWrite == 1 && ALUSrc0 == 0 && IDEX_Fwd_RegisterRt == EXMEM_Fwd_RegDst)begin
        Fwd_A <= 0;
        Fwd_B <= 1; 
    end
    
    //Forwarding from Memory Stage to Execution Stage
    else if(MEMWB_Fwd_RegWrite == 1 && ALUSrc1 == 0 && IDEX_Fwd_RegisterRs == MEMWB_Fwd_RegDst) begin
        Fwd_A <= 2;
        Fwd_B <= 0;
    end
    else if(MEMWB_Fwd_RegWrite == 1 && ALUSrc0 == 0  && IDEX_Fwd_RegisterRt == MEMWB_Fwd_RegDst) begin
        Fwd_A <= 0;
        Fwd_B <= 2;
    end
    else begin
        Fwd_A <= 0;
        Fwd_B <= 0;
    end
end


endmodule