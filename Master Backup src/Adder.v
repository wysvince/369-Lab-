`timescale 1ns / 1ps

module Adder(PCResult, ShiftLeft2Result, AddResult);

    input [31:0] PCResult, ShiftLeft2Result;

    output reg [31:0] AddResult;

    /* Please fill in the implementation here... */
    always @(*) begin
        AddResult <= PCResult + ShiftLeft2Result;
    end
    
endmodule

