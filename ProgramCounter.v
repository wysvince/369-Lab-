`timescale 1ns / 1ps

module ProgramCounter(Address, PCResult, Rst, Clk);
    
    input Rst, Clk;
	input [31:0] Address;
	output reg [31:0] PCResult;
    
    always @(posedge Clk)begin
        if(Rst == 1) begin
                PCResult <= 0;
        end
        else begin
                PCResult <= Address;
        end
    end

endmodule

