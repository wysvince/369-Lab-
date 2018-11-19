`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - Mux32Bit2To1.v
// Description - Performs signal multiplexing between 2 32-Bit words.
////////////////////////////////////////////////////////////////////////////////

module Mux32Bit3To1(out, inA, inB, inC, sel);

    input signed [31:0] inA;
    input signed [31:0] inB;
    input signed [31:0] inC;
    input [1:0] sel;
    //reg signed [31:0] b,c;
    
    output reg signed [31:0] out;
    
    always@(*) begin
        out <= 32'dx;
        if(sel == 2'b00) begin
            out <= inA;
        end
        else if (sel == 2'b01) begin 
//            b[31:16] <= 0;
//            b[15:0] <= inB;        
            out <= inB;
        end
        else if (sel == 2'b10) begin 
//            c[31:16] <= 0;
//            c[15:0] <= inC;        
            out <= inC;
        end
    end        

endmodule


// update 10/9	3:17pm
