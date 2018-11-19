`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - SignExtension.v
// Description - Sign extension module.
////////////////////////////////////////////////////////////////////////////////
module SignExtByte(in, out);

    /* A 16-Bit input word */
    input [7:0] in;
    
    /* A 32-Bit output word */
    output reg [31:0] out;   //using always @
    //output [31:0] out;   //using assign statement
    
    /* Fill in the implementation here ... */
    always@(in) begin
        out <= 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
        // halfword sign extended
        if(in[7] == 0) begin
            out[7:0] <= in;
            out[31:8] <= 24'h0;
        end
        else if (in[7] == 1) begin
            out[7:0] <= in;
            out[31:8] <= 24'b11111111111111111111111;
        end
    end

endmodule
