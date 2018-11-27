`timescale 1ns / 1ps

module Controller(readOp, readRS, readRT, read10_6, read5_0, JumpControl, JRegControl,	// fetch instructions
				  RegDst, ALUOp, ALUSrc0, ALUSrc1, MuxStore, // EX
		  		  Branch, MemRead, MemWrite,	// M
		  		  MemReg, RegWrite, MuxLoad);	//WB
    
	input  [5:0] readOp;  	// read [31:26] from Instruction Memory
	input  [4:0] readRS; 	// read [25:21] from Instruction Memory 
	input  [4:0] readRT;	// read [20:16] from Instruction Memory 
	input  [4:0] read10_6;	// read [10:6] from Instruction Memory  
	input  [5:0] read5_0;	// read [5:0] from Instruction Memory	

	output reg [5:0] ALUOp;		// output carries readOp to ALUController
	output reg [1:0] RegDst;			// Mux select: (0) rt for WriteReg, (1) rd for WriteReg
	output reg [1:0] ALUSrc0;			// ALU bottom Mux: (0) B = rt / (1) instr[15:0]
	output reg [1:0] ALUSrc1;			// ALU top Mux: (0) A = rs / (1) rt
	output reg [1:0] MuxStore;	// 3x1Mux to determine size store instructions content
							// (00) word, (01) halfword, (10) byte
	output reg [1:0] MuxLoad;	// 3x1Mux to determine size of load instructions content
							// (00) word, (01) halfword, (10) byte
    output reg JumpControl, JRegControl;							
	output reg Branch;			// (1) when operation is branch related
	output reg MemRead;			// (1) when reading from data memory
	output reg MemWrite;		// (1) when writing to data memory
	output reg RegWrite;		// (1) when writing to register
	output reg [1:0] MemReg;			// (1) when write from data memory to register
	
	initial begin
	   JumpControl <= 0;
	end
	
	always@(readOp, readRS, readRT, read10_6, read5_0)begin
		//initialized all reg cuz of syn warnings
	    ALUOp <= 6'dx;RegDst <= 2'dx;ALUSrc0 <= 2'd0; ALUSrc1 <= 2'd0;
	    MuxStore <= 2'dx;MuxLoad <= 2'dx;JumpControl <= 1'dx; 
	    JRegControl <= 1'dx;Branch <= 1'dx;MemRead <= 1'dx;
	    MemWrite <= 1'dx;RegWrite <= 1'dx; MemReg <= 2'dx;

        // nop
        if (readOp == 0 && readRS == 0 && readRT == 0 && read10_6 == 0 && read5_0 == 0) begin
        ALUOp <= 6'd0; ALUSrc0 <= 2'b00; ALUSrc1 <= 2'b00; JumpControl <= 0; Branch <= 0; MemRead <= 1'b0; MemWrite <= 1'b0; RegWrite <= 0; JRegControl <= 0;
        end
		// sll
		if(readOp == 6'd0 && readRS == 5'd0 && read10_6 != 0 && read5_0 == 6'd0) begin
		ALUOp <= 6'd1; RegDst <= 2'b01; ALUSrc0 <= 2'b10; ALUSrc1 <= 2'b10; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// madd
		if(readOp == 6'd28 && read10_6 == 5'd0 && read5_0 == 6'd0) begin
		ALUOp <= 6'd2; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 0;  JumpControl <= 0; JRegControl <= 0;
		end
		// rotr
		if(readOp == 6'd0 && readRS == 5'd1 && read5_0 == 6'd2) begin
		ALUOp <= 6'd3; RegDst <= 2'b01; ALUSrc0 <= 2'b10; ALUSrc1 <= 2'b10; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// srl
		if(readOp == 6'd0 && readRS == 5'd0 && read5_0 == 6'd2) begin
		ALUOp <= 6'd4; RegDst <= 2'b01; ALUSrc0 <= 2'b10; ALUSrc1 <= 2'b10; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// mul
		if(readOp == 6'd28 && read10_6 == 5'd0 && read5_0 == 6'd2) begin
		ALUOp <= 6'd5; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// sra
		if(readOp == 6'd0 && readRS == 5'd0 && read5_0 == 6'd3) begin
		ALUOp <= 6'd6; RegDst <= 2'b01; ALUSrc0 <= 2'b10; ALUSrc1 <= 2'b01; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// sllv
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd4) begin
		ALUOp <= 6'd7; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// msub
		if(readOp == 6'd28 && read10_6 == 5'd0 && read5_0 == 6'd4) begin
		ALUOp <= 6'd8; RegDst <= 0; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 0;  JumpControl <= 0; JRegControl <= 0;
		end
		// rotrv
		if(readOp == 6'd0 && read10_6 == 5'd1 && read5_0 == 6'd6) begin
		ALUOp <= 6'd9; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// srlv
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd6) begin
		ALUOp <= 6'd10; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// srav
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd7) begin
		ALUOp <= 6'd11; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// jump reg
		if(readOp == 6'd0 && readRT == 5'd0 && read5_0 == 6'd8) begin
		ALUOp <= 6'd12; Branch <= 1; JumpControl <= 0; 
		MemWrite <= 1'b0; JRegControl <= 1;
		end
		// movz
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd10) begin
		ALUOp <= 6'd13; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// movn
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd11) begin
		ALUOp <= 6'd14; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// mfhi
		if(readOp == 6'd0 && readRS == 5'd0 && readRT == 5'd0 && read10_6 == 5'd0 && read5_0 == 6'd16) begin
		ALUOp <= 6'd15; RegDst <= 2'b01; Branch <= 0; MemRead <= 0; MemWrite <= 1'b0; 
		RegWrite <= 1;  JumpControl <= 0; JRegControl <= 0; MemReg <= 2'd0;
		end
		// mthi
		if(readOp == 6'd0 && readRT == 5'd0 && read10_6 == 5'd0 && read5_0 == 6'd17) begin
		ALUOp <= 6'd16; ALUSrc1 <= 0; Branch <= 0; MemRead <= 0; MemWrite <= 1'b0; 
		RegWrite <= 0;  JumpControl <= 0; JRegControl <= 0;
		end
		// mflo
		if(readOp == 6'd0 && readRS == 5'd0 && readRT == 5'd0 && read10_6 == 5'd0 && read5_0 == 6'd18) begin
		ALUOp <= 6'd17; RegDst <= 2'b01; Branch <= 0; MemRead <= 0; MemWrite <= 1'b0; 
		RegWrite <= 1;  JumpControl <= 0; JRegControl <= 0;MemReg <= 2'd0;
		end
		// mtlo
		if(readOp == 6'd0 && readRT == 5'd0 && read10_6 == 5'd0 && read5_0 == 6'd19) begin
		ALUOp <= 6'd18; ALUSrc1 <= 0; Branch <= 0; MemRead <= 0; MemWrite <= 1'b0; 
		RegWrite <= 0;  JumpControl <= 0; JRegControl <= 0;
		end
		// mult
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd24) begin
		ALUOp <= 6'd19; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0; MemRead <= 0; 
		MemWrite <= 1'b0; RegWrite <= 0;  JumpControl <= 0; JRegControl <= 0;
		end
		// multu
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd25) begin
		ALUOp <= 6'd20; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0; MemRead <= 0; 
		MemWrite <= 1'b0; RegWrite <= 0;  JumpControl <= 0; JRegControl <= 0;
		end
		// add
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd32) begin
		ALUOp <= 6'd21; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// seb
		if(readOp == 6'd31 && readRS == 5'd0 && read10_6 == 5'd16 && read5_0 == 6'd32) begin
		ALUOp <= 6'd22; RegDst <= 2'b01; ALUSrc0 <= 0; Branch <= 0; MemRead <= 0; 
		MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// seh
		if(readOp == 6'd31 && readRS == 5'd0 && read10_6 == 5'd24 && read5_0 == 6'd32) begin
		ALUOp <= 6'd23; RegDst <= 2'b01; ALUSrc0 <= 0; Branch <= 0; MemRead <= 0; 
		MemWrite <= 1'b0; RegWrite <= 1;MemReg <= 0; JumpControl <= 0;   JRegControl <= 0;
		end
		// addu
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd33) begin
		ALUOp <= 6'd24; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// sub
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd34) begin
		ALUOp <= 6'd25; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// and
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd36) begin
		ALUOp <= 6'd26; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// or
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd37) begin
		ALUOp <= 6'd27; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// xor
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd38) begin
		ALUOp <= 6'd28; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// nor
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd39) begin
		ALUOp <= 6'd29; RegDst <= 2'b01; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// slt
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd42) begin
		ALUOp <= 6'd30; RegDst <= 2'd1; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 0; 
		RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; MemWrite <= 1'b0; JRegControl <= 0;
		end
		// sltu
		if(readOp == 6'd0 && read10_6 == 5'd0 && read5_0 == 6'd43) begin
		ALUOp <= 6'd31; RegDst <= 2'b01; ALUSrc0 <= 2'b10; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// addiu
		if(readOp == 6'd9) begin
		ALUOp <= 6'd32; RegDst <= 0; ALUSrc0 <= 2'b01; ALUSrc1 <= 2'b00; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// slti
		if(readOp == 6'd10) begin
		ALUOp <= 6'd33; RegDst <= 0; ALUSrc0 <= 2'b01; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// sltiu
		if(readOp == 6'd11) begin
		ALUOp <= 6'd34; RegDst <= 0; ALUSrc0 <= 2'b10; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// andi
		if(readOp == 6'd12) begin
		ALUOp <= 6'd35; RegDst <= 0; ALUSrc0 <= 2'b10; ALUSrc1 <= 2'b00; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// ori
		if(readOp == 6'd13) begin
		ALUOp <= 6'd36; RegDst <= 0; ALUSrc0 <= 2'b01; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// xori
		if(readOp == 6'd14) begin
		ALUOp <= 6'd37; RegDst <= 0; ALUSrc0 <= 2'b01; ALUSrc1 <= 0; Branch <= 0; 
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// lui
		if(readOp == 6'd15 && readRS == 5'd0) begin
		ALUOp <= 6'd38; RegDst <= 0; ALUSrc0 <= 0; ALUSrc0 <= 2'd2; Branch <= 0; MemRead <= 0; 
		MemWrite <= 1'b0; RegWrite <= 1;  MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
		end
		// jump
		if(readOp == 6'd2) begin
		ALUOp <= 6'd39; Branch <= 0; ALUSrc1 <= 0; RegWrite <= 0; 
		MemWrite <= 1'b0; JumpControl <= 1;
		end
		// jal
		if(readOp == 6'd3) begin
		ALUOp <= 6'd40; Branch <= 0; RegDst <= 2'b10; MemReg <= 2'b10; 
		RegWrite <= 1; MemWrite <= 1'b0; JumpControl <= 1; RegDst <= 2'd2;
		JRegControl <= 1;
		end
		// lb
		if(readOp == 6'd32) begin
		ALUOp <= 6'd41; RegDst <= 0; ALUSrc0 <= 2'd1; ALUSrc1 <= 2'd0; Branch <= 0;
		MemRead <= 1; MemWrite <= 1'b0; RegWrite <= 1;   MemReg <= 2'd1; MuxLoad <= 2'd2;//using sign extend imm 
		JumpControl <= 0; JRegControl <= 0;
		end
		// lh
		if(readOp == 6'd33) begin
		ALUOp <= 6'd42; RegDst <= 0; ALUSrc0 <= 2'd1; ALUSrc1 <= 2'd0; Branch <= 0;
		MemRead <= 1; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 2'd1; MuxLoad <= 2'd1; //using sign extend imm
		JumpControl <= 0; JRegControl <= 0;
		end
		// lw
		if(readOp == 6'd35) begin
		ALUOp <= 6'd43; RegDst <= 0; ALUSrc0 <= 2'd1; ALUSrc1 <= 2'd0; Branch <= 0; JRegControl <= 0;
		MemRead <= 1; MemWrite <= 1'b0; RegWrite <= 1;   MemReg <= 2'd1; MuxLoad <= 2'd0; JumpControl <= 0; //using sign extend imm
		end
		// sb
		if(readOp == 6'd40) begin
		ALUOp <= 6'd44; ALUSrc0 <= 2'd1; ALUSrc1 <= 2'd0; Branch <= 0; RegWrite <= 1'dx;
		MemRead <= 0; MemWrite <= 1'b1; MuxStore <= 2'd2; JumpControl <= 0; JRegControl <= 0;
		end
		// sh
		if(readOp == 6'd41) begin
		ALUOp <= 6'd45; ALUSrc0 <= 2'd1; ALUSrc1 <= 2'd0; Branch <= 0; RegWrite <= 1'dx;
		MemRead <= 0; MemWrite <= 1'b1; MemReg <= 0;  MuxStore <= 2'd1; JumpControl <= 0; JRegControl <= 0;
		end
		// sw
		if(readOp == 6'd43) begin
		ALUOp <= 6'd46; ALUSrc0 <= 2'd1; ALUSrc1 <= 2'd0; Branch <= 0; RegWrite <= 1'dx;
		MemRead <= 0; MemWrite <= 1'b1; MuxStore <= 2'd0; JumpControl <= 0; JRegControl <= 0;
		end
		// bgez
		if(readOp == 6'd1 && readRT == 5'd1) begin
		ALUOp <= 6'd47; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 1; 
		RegWrite <= 0; MemWrite <= 1'b0; JumpControl <= 0;  JRegControl <= 0; 
		end
		// bltz
		if(readOp == 6'd1 && readRT == 5'd0) begin
		ALUOp <= 6'd48; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 1; 
		RegWrite <= 0; MemWrite <= 1'b0; JumpControl <= 0;  JRegControl <= 0;
		end
		// beq
		if(readOp == 6'd4) begin
		ALUOp <= 6'd49; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 1; 
		RegWrite <= 0; MemWrite <= 1'b0; JumpControl <= 0;  JRegControl <= 0;
		end
		// bne
		if(readOp == 6'd5) begin
		ALUOp <= 6'd50; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 1; 
		RegWrite <= 0; MemWrite <= 1'b0; JumpControl <= 0;  JRegControl <= 0;
		end
		// blez
		if(readOp == 6'd6 && readRT == 5'd0) begin
		ALUOp <= 6'd51; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 1; 
		RegWrite <= 0; MemWrite <= 1'b0; JumpControl <= 0;  JRegControl <= 0;
		end
		// bgtz
		if(readOp == 6'd7 && readRT == 5'd0) begin
		ALUOp <= 6'd52; ALUSrc0 <= 0; ALUSrc1 <= 0; Branch <= 1; 
		RegWrite <= 0; MemWrite <= 1'b0; JumpControl <= 0;  JRegControl <= 0;
		end
		// addi
		if(readOp == 6'd8) begin
		ALUOp <= 6'd53; RegDst <= 0; ALUSrc0 <= 2'b01; ALUSrc1 <= 0; Branch <= 0;
		MemRead <= 0; MemWrite <= 1'b0; RegWrite <= 1; MemReg <= 0; JumpControl <= 0; JRegControl <= 0;
        end
	end

endmodule

// Updated: 10/14	9:25PM