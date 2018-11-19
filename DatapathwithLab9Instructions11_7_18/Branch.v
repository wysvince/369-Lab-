`timescale 1ns / 1ps


module Branch(A, B, BranchResult);

    input A, B;

    output reg BranchResult;

    always @(A,B) begin
        BranchResult <= A & B;
    end
    
endmodule

