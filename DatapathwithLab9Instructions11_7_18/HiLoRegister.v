`timescale 1ns / 1ps

module HiLoReg(HI_in, LO_in, HI_out, LO_out, Clk, Rst);

	
	input Clk, Rst;	

	input [31:0] HI_in, LO_in; 
	reg [31:0] readHI, readLO;
	output reg [31:0] HI_out, LO_out;
	
	
//    always@(Rst) begin
//        if(Rst == 1)begin
//            readHI <= 0;
//            readLO <= 0;
//        end
//    end
    
    always@(negedge Clk)begin
        readHI <= HI_in;
        readLO <= LO_in;
    end
    
	always@(posedge Clk) begin
	if(Rst == 1)begin
	   HI_out <= 0;
       LO_out <= 0;
	end
	
	else begin
        HI_out <= readHI;
        LO_out <= readLO;
    end
	end

endmodule