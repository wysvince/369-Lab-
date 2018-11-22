`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - ALU32Bit.v
// Description - 32-Bit wide arithmetic logic unit (ALU).
//
// INPUTS:-
// ALUControl: N-Bit input control bits to select an ALU operation.
// A: 32-Bit input port A.
// B: 32-Bit input port B.
//
// OUTPUTS:-
// ALUResult: 32-Bit ALU result output.
// ZERO: 1-Bit output flag. 
//
// FUNCTIONALITY:-
// Design a 32-Bit ALU, so that it supports all arithmetic operations 
// needed by the MIPS instructions given in Labs5-8.docx document. 
//   The 'ALUResult' will output the corresponding result of the operation 
//   based on the 32-Bit inputs, 'A', and ''b. 
//   The 'Zero' flag is high when 'ALUResult' is '0'. 
//   The 'ALUControl' signal should determine the function of the ALU 
//   You need to determine the bitwidth of the ALUControl signal based on the number of 
//   operations needed to support. 
////////////////////////////////////////////////////////////////////////////////

module ALU32Bit(ALUControl, A, B, ALUResult, Zero, HI_in, LO_in, HI_out, LO_out);

	input [5:0] ALUControl; 		// control bits for ALU operation
                               		// you need to adjust the bitwidth as needed
	input [31:0] A, B;	   	 		// inputs from Register

	output reg [31:0] ALUResult;		// answer
	output reg Zero;	   		    	// Zero=1 if ALUResult == 0
	
	
	input [31:0] HI_in, LO_in;     // inputs from Hi/Lo register
	output reg    [31:0] HI_out, LO_out;	// outputs to Hi/Lo register

	reg    [31:0] temp0;
	reg    [31:0] temp4;
	reg    [63:0] temp1;
	reg    [63:0] temp2; 
	reg    [63:0] temp3;	          // temp variable 64bits
	reg    [4:0]  sa;				  // shift amount 5bits
	reg    [4:0]  i;
 
    initial begin
    temp0 = 0; temp1 = 0; temp2 = 0; temp3 = 0; sa = 0; HI_out = 0; LO_out = 0;
    //ALUResult <= 32'dx;
    end
 
	always @(*) begin
		// nop
		if(ALUControl == 6'd0) begin
            ALUResult <= 0;
        end
	 else if(ALUControl == 6'd1) begin
			sa = B[10:6];
			ALUResult <= A << sa;
		end
		// madd
		else if(ALUControl == 6'd2) begin
			temp1 = {16'd0, A} * {16'd0, B};
			temp2 = {HI_in, LO_in};
			temp3 = temp1 + temp2;
			HI_out <= temp3[63:32];
			LO_out <= temp3[31:0];
		end
		// rotr: set A = rt
		else if(ALUControl == 6'd3) begin
			sa = B[10:6];
			temp1 = 31 - sa;
            ALUResult <= ((A >> sa) | (A << (32-sa)));   
		end
		// srl: set A = rt
		else if(ALUControl == 6'd4) begin
			sa = B[10:6];
			ALUResult <= A >> sa;
		end
		// mul
		else if(ALUControl == 6'd5) begin
			temp1 = {16'd0, A} * {16'd0, B};
			ALUResult <= temp1[31:0];
		end
		// sra: set A = rt
		else if(ALUControl == 6'd6) begin
			sa = B[10:6];
			ALUResult <= A >>> sa;
		end
		// sllv: $rd = $rt << $rs[4:0]
		else if(ALUControl == 6'd7) begin
			ALUResult <= B << A[4:0];
		end
		// msub
		else if(ALUControl == 6'd8) begin
			temp1 = {16'd0, A} * {16'd0, B};
			temp2 = {HI_in, LO_in};
			temp3 = temp2 - temp1;
			HI_out <= temp3[63:32];
			LO_out <= temp3[31:0];
		end
		// rotrv
		else if(ALUControl == 6'd9) begin
			sa = A[4:0];
            temp1 = 31 - sa;
            ALUResult <= ((B >> sa) | (B << (32-sa)));
		end
		// srlv: $rd = $rt >> $rs[4:0]
		else if(ALUControl == 6'd10) begin
			sa = A[4:0];
			ALUResult <= B >> sa;
		end
		// srav: $rd = $rt >>> $rs[4:0]
		else if(ALUControl == 6'd11) begin
			sa = A[4:0];
			ALUResult <= B >>> sa;
		end
		// jr
		else if(ALUControl == 6'd12) begin
			ALUResult <= 32'd0;
		end
		// movz: if value in rt is zero, content of rs are placed in rd 
		else if(ALUControl == 6'd13) begin
			if(B == 0) begin
				ALUResult <= A;
			end
		end
		// movn: if value in rt is not equal zero, content of rs are placed into rd
		else if(ALUControl == 6'd14) begin
			if(B != 0) begin
				ALUResult <= A;
			end
		end
		// mfhi: $rd = $hi
		else if(ALUControl == 6'd15) begin
			ALUResult <= HI_in;
		end
		// mthi: $hi = $rs
		else if(ALUControl == 6'd16) begin
			HI_out <= A;
		end
		// mflo: $rd = $lo
		else if(ALUControl == 6'd17) begin
			ALUResult <= LO_in;
		end
		// mtlo: $lo = $rs
		else if(ALUControl == 6'd18) begin
			LO_out <= A;
		end
		// mult: {$hi, $lo} = ($rs Ã- $rt)
		else if(ALUControl == 6'd19) begin
			temp1 = {16'd0, A} * {16'd0, B};
			LO_out <= temp1[31:0];
			HI_out <= temp1[63:32];
		end
		// multu: {$hi, $lo} = ($rs Ã- $rt)
		else if(ALUControl == 6'd20) begin
			temp1 = {16'd0,A};
			temp2 = {16'd0,B};
			temp3 = temp1 * temp2;
			LO_out <= temp3[31:0];
			HI_out <= temp3[63:32];
		end
		// add: $rd = $rs + $rt
		else if(ALUControl == 6'd21) begin
			ALUResult <= A + B;
		end
		// seb:sign extend byte of rt[7:0]
		else if(ALUControl == 6'd22) begin
			ALUResult[7:0] <= B[7:0];
			if(B[7] == 1'b1)begin
		    ALUResult[31:8] <= 24'b11111_11111_11111_11111_1111;
			end
			else if(B[7] == 1'b0) begin
		    ALUResult[31:8] <= 24'b00000_00000_00000_00000_0000;
			end
		end
		// seh:sign extend halfword of rt[15:0]
		else if(ALUControl == 6'd23) begin
			ALUResult[15:0] <= B[15:0];
			if(B[15] == 1'b0)begin
				ALUResult[31:16] <= 16'd0;
			end
			else if(B[15] == 1'b1) begin
				ALUResult[31:16] <= 16'd1;
			end
		end
		// addu: $rd = $rs + $rt
		else if(ALUControl == 6'd24) begin
			ALUResult <= A + B;
		end
		// sub: $rd = $rs - $rt
		else if(ALUControl == 6'd25) begin
			ALUResult <= A - B;
		end
		// and: $rd = $rs & $rt
		else if(ALUControl == 6'd26) begin
			ALUResult <= A & B;
		end
		// or: $rd = $rs | $rt
		else if(ALUControl == 6'd27) begin
			ALUResult <= A | B;
		end
		// xor: $rd = $rs ^ $rt
		else if(ALUControl == 6'd28) begin
			ALUResult <= A ^ B;
		end
		// nor: $rd = Â¬ ( $rs | $rt )
		else if(ALUControl == 6'd29) begin
			ALUResult <= ~(A | B);
		end
		// slt: $rs < $rt ? $rd = 1 : $rd = 0
		else if(ALUControl == 6'd30) begin
			if(A < B) begin
				ALUResult <= 32'd1;
			end
			else begin
				ALUResult <= 32'd0;
			end	
		end
		// sltu: $rs < $rt ? $rd = 1 : $rd = 0
		else if(ALUControl == 6'd31) begin
			if(A < 0)begin
			     temp0 = 0;
			end
			else begin
			     temp0 = A;
			end
			if(B < 0) begin
			     temp4 = 0;
			end
			else begin
			     temp4 = B;
			end
			if(temp0 < temp4) begin
				ALUResult <= 32'd1;
			end
			else begin
				ALUResult <= 32'd0;
			end	
		end
		// addiu
		else if(ALUControl == 6'd32) begin
			ALUResult <= A + B;
		end
		// slti
		else if(ALUControl == 6'd33) begin
			if(A < B) begin
				ALUResult <= 32'd1;
			end
			else begin
				ALUResult <= 32'd0;
			end	
		end
		// sltiu
		else if(ALUControl == 6'd34) begin
			if(A < 0)begin
                 temp0 = 0;
            end
            else begin
                 temp0 = A;
            end
            if(B < 0) begin
                 temp4 = 0;
            end
            else begin
                 temp4 = B;
            end
            if(temp0 < temp4) begin
                ALUResult <= 32'd1;
            end
            else begin
                ALUResult <= 32'd0;
            end    
		end
		// andi
		else if(ALUControl == 6'd35) begin
			ALUResult <= A + B;
		end
		// ori
		else if(ALUControl == 6'd36) begin
			ALUResult <= A | B;
		end
		// xori: rt <- rs XOR immediate
		else if(ALUControl == 6'd37) begin
			ALUResult <= A ^ B;
		end
		// lui: rt <- immediate || 016
		else if(ALUControl == 6'd38) begin
			temp0 = {B[16:0],16'd0};
			ALUResult <= temp0; 
		end
		// j
		else if(ALUControl == 6'd39) begin
			ALUResult <= 32'd0;
		end
		// jal
		else if(ALUControl == 6'd40) begin
			ALUResult <= 32'd0;
		end
		// lb: load byte
		else if(ALUControl == 6'd41) begin
			ALUResult <= A + B;
		end
		// lh:load halfword
		else if(ALUControl == 6'd42) begin
			ALUResult <= A + B;
		end
		// lw: load word
		else if(ALUControl == 6'd43) begin
			 ALUResult <= A + B;
		end
		// sb: store byte
		else if(ALUControl == 6'd44) begin
			ALUResult <= A + B;
		end
		// sh: store halfword
		else if(ALUControl == 6'd45) begin
			ALUResult <= A + B;
		end
		// sw: store word
		else if(ALUControl == 6'd46) begin
			ALUResult <= A + B;
		end
		// bgez: rs be greater than or equal to zero
		else if(ALUControl == 6'd47) begin
			if($signed(A) >= 0) begin
				ALUResult <= 32'd0;
			end
			else begin
				ALUResult <= 32'd1;
			end
		end
		// bltz: rs be less than zero
		else if(ALUControl == 6'd48) begin
			if($signed(A) < 0) begin
				ALUResult <= 32'd0;
			end
			else begin
				ALUResult <= 32'd1;
			end
		end
		// beq: rs equal to rt
		else if(ALUControl == 6'd49) begin
			if($signed(A) == $signed(B)) begin
				ALUResult <= 32'd0; // Zero Flag = 1
			end
			else begin
				ALUResult <= 32'd1; //  Zero Flag = 0
			end
		end
		// bne: rs not equal to rt
		else if(ALUControl == 6'd50) begin
			if($signed(A) != $signed(B)) begin
				ALUResult <= 32'd0;
			end
			else begin
				ALUResult <= 32'd1;
			end
		end
		// blez: rs be less than or equal to zero
		else if(ALUControl == 6'd51) begin
			if($signed(A) <= 0) begin
				ALUResult <= 32'd0;
			end
			else begin
				ALUResult <= 32'd1;
			end
		end
		// bgtz: rs be greater than zero
		else if(ALUControl == 6'd52) begin
			if($signed(A) > 0) begin
				ALUResult <= 32'd0;
			end
			else begin
				ALUResult <= 32'd1;
			end
		end
		// addi:
		else if(ALUControl == 6'd53) begin
			ALUResult <= A + B;
		end
	end
	always @(*) begin
        if(ALUResult == 0) begin
            Zero = 1;    //Zero flag is high
        end
        else begin
            Zero = 0;    // Zero flag is low
        end
    end  
endmodule

// updated 10/14/2018  9:03PM