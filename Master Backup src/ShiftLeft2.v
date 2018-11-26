`timescale 1ns / 1ps

module ShiftLeft2(in, out);

    input [31:0] in;

    output reg [31:0] out;

    /* Please fill in the implementation here... */
    always @(in) begin
        out <= in << 2;
    end
    
endmodule

