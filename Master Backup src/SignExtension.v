`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - SignExtension.v
// Description - Sign extension module.
////////////////////////////////////////////////////////////////////////////////
module SignExtension(in, out);

    /* A 16-Bit input word */
    input [15:0] in;
    
    /* A 32-Bit output word */
    output reg [31:0] out;   //using always @
    //output [31:0] out;   //using assign statement
    
    /* Fill in the implementation here ... */
    always@(in) begin
        out <= 32'dx;
        // halfword sign extended
        if(in[15] == 0) begin
            out[15:0] <= in;
            out[31:16] <= 16'b0000000000000000;
        end
        else if (in[15] == 1) begin
            out[15:0] <= in;
            out[31:16] <= 16'b1111111111111111;
        end
    end

endmodule
