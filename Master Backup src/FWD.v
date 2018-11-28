`timescale 1ns / 1ps

module FWD(IDEX_Fwd_RegisterRs, IDEX_Fwd_RegisterRd, IDEX_Fwd_RegisterRt, 
           EXMEM_Fwd_RegWrite, EXMEM_Fwd_RegDst, 
           MEMWB_Fwd_RegWrite, MEMWB_Fwd_RegDst,
           Decode_RegisterRs, Decode_RegisterRt,
           Controller_Fwd_OpCode, ALUSrc0, ALUSrc1, 
           Fwd_A, Fwd_B, Fwd_C);

input [31:0] IDEX_Fwd_RegisterRs, IDEX_Fwd_RegisterRd, IDEX_Fwd_RegisterRt;
input [31:0] Decode_RegisterRs, Decode_RegisterRt;
input EXMEM_Fwd_RegWrite, MEMWB_Fwd_RegWrite;
input [5:0] Controller_Fwd_OpCode;
input [1:0] ALUSrc0, ALUSrc1;
input [31:0] EXMEM_Fwd_RegDst, MEMWB_Fwd_RegDst;

output reg [1:0] Fwd_A, Fwd_B, Fwd_C;

always@(*)begin
    Fwd_A <= 2'b00;
    Fwd_B <= 2'b00;
    Fwd_C <= 2'b00;
    // check types of operation that requires Forwarding
//    if(Controller_Fwd_OpCode == 0)begin
    
//    end
     // Rs and Rt depencies:
   // WriteBack RegDst -> Rs
   // Memory RegDst -> Rt
   if(EXMEM_Fwd_RegWrite == 1 && ALUSrc1 == 0 && IDEX_Fwd_RegisterRs == MEMWB_Fwd_RegDst
           && MEMWB_Fwd_RegWrite == 1 && ALUSrc0 == 0 && IDEX_Fwd_RegisterRt == EXMEM_Fwd_RegDst)
   begin
       Fwd_A <= 2;
       Fwd_B <= 1; 
   end
   // Rs and Rt depencies:
   // Memory RegDst -> Rs
   // WriteBack RegDst -> Rt
   else if(EXMEM_Fwd_RegWrite == 1 && ALUSrc1 == 0 && IDEX_Fwd_RegisterRs == EXMEM_Fwd_RegDst
           && MEMWB_Fwd_RegWrite == 1 && ALUSrc0 == 0 && IDEX_Fwd_RegisterRt == MEMWB_Fwd_RegDst)
   begin
       Fwd_A <= 1;
       Fwd_B <= 2; 
   end
    // sll case:
    else if(EXMEM_Fwd_RegWrite == 1 && ALUSrc1 == 2 && ALUSrc0 == 2 && IDEX_Fwd_RegisterRt == EXMEM_Fwd_RegDst)begin
        Fwd_A <= 1; 
        Fwd_B <= 0;
    end
    //Forwarding from Memory Stage to Execution Stage
    else if(EXMEM_Fwd_RegWrite == 1 && ALUSrc1 == 0 && IDEX_Fwd_RegisterRs == EXMEM_Fwd_RegDst)begin
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
   
   // super fast forward from Memory to Decode
   else if(EXMEM_Fwd_RegWrite == 1 && Decode_RegisterRs == EXMEM_Fwd_RegDst &&
           Controller_Fwd_OpCode != 6'd35 && Decode_RegisterRt == EXMEM_Fwd_RegDst)begin
        Fwd_C <= 2;
   end
   
   else if(EXMEM_Fwd_RegWrite == 1 && Decode_RegisterRs == EXMEM_Fwd_RegDst &&
          Controller_Fwd_OpCode == 6'd35 && Decode_RegisterRt == EXMEM_Fwd_RegDst)begin
          Fwd_C <= 2;
  end
   
    else begin
        Fwd_A <= 0;
        Fwd_B <= 0;
        Fwd_C <= 0;
    end
end


endmodule