`timescale 1ns / 1ps

module ProgramCounter(Address, PCResult, flush, Rst, Clk);
    
    input Rst, Clk, flush;
	input [31:0] Address;
	output reg [31:0] PCResult;
    
    always @(posedge Clk)begin
        if(Rst == 1) begin
                PCResult <= 0;
        end
        else if(flush == 1)begin
            PCResult <= Address - 4;
        end
        else begin
            PCResult <= Address;
        end
    end

endmodule

