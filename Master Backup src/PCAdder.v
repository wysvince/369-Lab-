`timescale 1ns / 1ps

module PCAdder(PCResult, PCAddResult);
    
    input [31:0] PCResult;
    output reg [31:0] PCAddResult;
    
    initial begin
        PCAddResult <= 0;
    end
    
    always @(PCResult) begin
        PCAddResult <= PCResult + 32'd4;
    end
    
endmodule

