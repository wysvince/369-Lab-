`timescale 1ns / 1ps

module Mux32Bit2To1(out, inA, inB, sel);
    
    output reg [31:0] out;
    
    input [31:0] inA;
    input [31:0] inB;
    input sel;
    
//    initial begin
//        out <= 0;
//    end
    
    always@(*) begin
        out <= 32'dx;//inilized out cuz of syn warning
        if(sel == 0) begin
            out <= inA;
        end
        else if (sel == 1) begin 
            out <= inB;
        end
    end        

endmodule
