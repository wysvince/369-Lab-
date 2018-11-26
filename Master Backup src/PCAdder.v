`timescale 1ns / 1ps

module PCAdder(PCResult, flush, PCAddResult);
    
    input flush;
    input [31:0] PCResult;
    output reg [31:0] PCAddResult;
    
    initial begin
        PCAddResult <= 0;
    end
    
    always @(PCResult) begin
        if(flush == 1)begin
            PCAddResult <= PCResult; 
        end
        else begin
            PCAddResult <= PCResult + 32'd4;
        end
    end
    
endmodule

