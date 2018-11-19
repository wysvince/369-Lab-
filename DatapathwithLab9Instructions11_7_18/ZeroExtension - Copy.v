`timescale 1ns / 1ps

module ZeroExtension(in, out);
// Input from Immediate/Offset field of Instruction Memory
input [15:0] in;
// Output to IDEX register -> Execution Stage
output reg [31:0] out;

always@(in)begin
    out [15:0] <= in;
    out [31:16] <= 16'd0;
end

endmodule
