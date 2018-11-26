`timescale 1ns / 1ps

module HDU(EXE_MemRead, EXE_WriteRegDst, IFID_AddressRs, IFID_AddressRt, flush, IFID_flush, Controller_flush);

input EXE_MemRead;
input [31:0] EXE_WriteRegDst, IFID_AddressRs, IFID_AddressRt;
output reg flush, IFID_flush;
output reg Controller_flush;

initial begin
    flush <= 0;
    IFID_flush <= 0;
    Controller_flush <= 0;
end

always @(*)begin
//    flush <= 0;
//    IFID_flush <= 0;
//    Controller_flush <= 0;
    // Load Word hazard:
        if(EXE_MemRead == 1 && EXE_WriteRegDst != 32'd0 && (EXE_WriteRegDst == IFID_AddressRs || EXE_WriteRegDst == IFID_AddressRt))begin
            flush <= 1;
            IFID_flush <= 1;
            Controller_flush <= 0;
        end
        else begin
            flush <= 0;
            IFID_flush <= 0;
            Controller_flush <= 0;
        end
    
end

endmodule