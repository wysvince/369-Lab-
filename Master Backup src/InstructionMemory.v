`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory  1
// Module - InstructionMemory.v
// Description - 32-Bit wide instruction memory.
//
// INPUT:-
// Address: 32-Bit address input port.
//
// OUTPUT:-
// Instruction: 32-Bit output port.
//
// FUNCTIONALITY:-
// Similar to the DataMemory, this module should also be byte-addressed
// (i.e., ignore bits 0 and 1 of 'Address'). All of the instructions will be 
// hard-coded into the instruction memory, so there is no need to write to the 
// InstructionMemory.  The contents of the InstructionMemory is the machine 
// language program to be run on your MIPS processor.
//
//
//we will store the machine code for a code written in C later. for now initialize 
//each entry to be its index * 3 (memory[i] = i * 3;)
//all you need to do is give an address as input and read the contents of the 
//address on your output port. 
// 
//Using a 32bit address you will index into the memory, output the contents of that specific 
//address. for data memory we are using 1K word of storage space. for the instruction memory 
//you may assume smaller size for practical purpose. you can use 128 words as the size and 
//hardcode the values.  in this case you need 7 bits to index into the memory. 
//
//be careful with the least two significant bits of the 32bit address. those help us index 
//into one of the 4 bytes in a word. therefore you will need to use bit [8-2] of the input address. 


////////////////////////////////////////////////////////////////////////////////

module InstructionMemory(Address, Instruction); 

    input [31:0] Address;        // Input Address 

    output reg [31:0] Instruction;    // Instruction at memory location Address
 
    reg [31:0] memory[0:500];
    //integer Index = 32'd2;
    reg [31:0] temp;
    initial begin
    memory[0] <= 32'b00110100000100100000000000000000 ;		   // 	ori	$s2, $zero, 0			   // main
    memory[1] <= 32'b10001110010100100000000000000000 ;        //     lw    $s2, 0($s2)            
    memory[2] <= 32'b00110100000100110000000000000000 ;        //     ori    $s3, $zero, 0            
    memory[3] <= 32'b10001110011100110000000000000100 ;        //     lw    $s3, 4($s3)            
    memory[4] <= 32'b00000010010100111000100000100000 ;        //     add    $s1, $s2, $s3            
    memory[5] <= 32'b00000010001100111010000000100010 ;        //     sub    $s4, $s1, $s3            
    memory[6] <= 32'b00000010001101001000100000100010 ;        //     sub    $s1, $s1, $s4            
    memory[7] <= 32'b01110010001100111010000000000010 ;        //     mul    $s4, $s1, $s3            
    memory[8] <= 32'b00000010001100111010000000100010 ;        //     sub    $s4, $s1, $s3            
    memory[9] <= 32'b00000010010100111000100000100000 ;        //     add    $s1, $s2, $s3            
    memory[10] <= 32'b01110010001101001011000000000010 ;        //     mul    $s6, $s1, $s4   
    memory[11] <= 32'b000000_10100_10110_10001_00000_100010 ;        //     sub    $s1, $s4, $s6         
    memory[12] <= 32'b00000010010101101000100000100000 ;        //     add    $s1, $s2, $s6            
    memory[13] <= 32'b00110110001100011010101010101010 ;        //     ori    $s1, $s1, 43690            
    memory[14] <= 32'b00000000000100011000101010000000 ;        //     sll    $s1, $s1, 10            
    memory[15] <= 32'b00100010001101010000000000000000 ;        //     addi    $s5, $s1, 0            
    memory[16] <= 32'b00100010101101110000000000000000 ;        //     addi    $s7, $s5, 0            
    memory[17] <= 32'b00110100000100100000000000011000 ;        //     ori    $s2, $zero, 24            
    memory[18] <= 32'b10001110010100010000000000000000 ;        //     lw    $s1, 0($s2)            
    memory[19] <= 32'b00000010001101011010000000100010 ;        //     sub    $s4, $s1, $s5            
    memory[20] <= 32'b00000010001101111011000000100100 ;        //     and    $s6, $s1, $s7            
    memory[21] <= 32'b00000010001101101011100000100101 ;        //     or    $s7, $s1, $s6            
    memory[22] <= 32'b00000010001100111001000000100010 ;        //     sub    $s2, $s1, $s3            
    memory[23] <= 32'b00000010010101010100000000100100 ;        //     and    $t0, $s2, $s5            
    memory[24] <= 32'b00000010110100100100100000100101 ;        //     or    $t1, $s6, $s2            
    memory[25] <= 32'b00000010010100100101000000100000 ;        //     add    $t2, $s2, $s2            
    memory[26] <= 32'b00110100000100010000000000000000 ;        //     ori    $s1, $zero, 0            
    memory[27] <= 32'b10101110001010010000000000000100 ;        //     sw    $t1, 4($s1)            
    memory[28] <= 32'b10001110001010100000000000000100 ;        //     lw    $t2, 4($s1)            
    memory[29] <= 32'b00000010001100111001000000100010 ;        //     sub    $s2, $s1, $s3            
    memory[30] <= 32'b00000010010101010101100000100101 ;        //     or    $t3, $s2, $s5            
    memory[31] <= 32'b00000010010100100110000000100000 ;        //     add    $t4, $s2, $s2            
    memory[32] <= 32'b00000010010100100101000000100101 ;        //     or    $t2, $s2, $s2            
    memory[33] <= 32'b00000010111010101010000000100000 ;        //     add    $s4, $s7, $t2            
    memory[34] <= 32'b00110100000010010000000000000000 ;        //     ori    $t1, $zero, 0            
    memory[35] <= 32'b10001101001010000000000000000000 ;        //     lw    $t0, 0($t1)            
    memory[36] <= 32'b10001101001010100000000000000100 ;        //     lw    $t2, 4($t1)            
    memory[37] <= 32'b10101101001010100000000000000000 ;        //     sw    $t2, 0($t1)            
    memory[38] <= 32'b10101101001010000000000000000100 ;        //     sw    $t0, 4($t1)            
    memory[39] <= 32'b10001101001010000000000000000000 ;        //     lw    $t0, 0($t1)            
    memory[40] <= 32'b10001101001010100000000000000100 ;        //     lw    $t2, 4($t1)            
    memory[41] <= 32'b00110100000001000000000000011000 ;        //     ori    $a0, $zero, 24            
    memory[42] <= 32'b00001000000000000000000000101101 ;        //     j    start            
    memory[43] <= 32'b00100000000001001111111111111111 ;        //     addi    $a0, $zero, -1            
    memory[44] <= 32'b00100000000001001111111111111111 ;        //     addi    $a0, $zero, -1            
    memory[45] <= 32'b10001100100100000000000000000100 ;        //     lw    $s0, 4($a0)            // start
    memory[46] <= 32'b10101100100100000000000000000000 ;        //     sw    $s0, 0($a0)            
    memory[47] <= 32'b00000110000000010000000000000011 ;        //     bgez    $s0, branch2         // branch1
    memory[48] <= 32'b00100010000100000000000000000001 ;        //     addi    $s0, $s0, 1            
    memory[49] <= 32'b00000110000000011111111111111111 ;        //     bgez    $s0, branch1            
    memory[50] <= 32'b00001000000000000000000000111110 ;        //     j    error            
    memory[51] <= 32'b00100000000100001111111111111111 ;        //     addi    $s0, $zero, -1       // branch2
    memory[52] <= 32'b00000110000000000000000000000100 ;        //     bltz    $s0, branch3            
    memory[53] <= 32'b00100000000100000000000000000001 ;        //     addi    $s0, $zero, 1            
    memory[54] <= 32'b00000000000100000000100000101010 ;        //     slt    $at, $zero, $s0            
    memory[55] <= 32'b00010100001000001111111111111101 ;        //     bne    $at, $zero, branch2            
    memory[56] <= 32'b00001000000000000000000000111110 ;        //     j    error            
    memory[57] <= 32'b00000110000000000000000000000011 ;        //     bltz    $s0, done            // branch3
    memory[58] <= 32'b00100000000100001111111111111111 ;        //     addi    $s0, $zero, -1            
    memory[59] <= 32'b00000110000000001111111111111111 ;        //     bltz    $s0, branch3            
    memory[60] <= 32'b00001000000000000000000000111110 ;        //     j    error            
    memory[61] <= 32'b00001000000000000000000000111101 ;        //     j    done                    // done
    memory[62] <= 32'b00001000000000000000000000111110 ;        //     j    error                   // error

    
    // test rd -> rs
//    memory[0]= 32'b000000_10001_10010_10000_00000_100000;   //  add $s1, $s2, $s3
//    memory[1]= 32'b000000_10000_10100_10101_00000_100010;   //  sub $s6, $s1, $s5

//    memory[0]= 32'h02538820;   // add $s1, $s2, $s3
//    memory[1]= 32'h02749020;   // add $s2, $s3, $s4
//    memory[2] = 32'h0235B022;  // sub $s6, $s1, $s5
    
//    memory[0] = 32'h8e510000;   // lw $s1, 0($s2)
//    memory[1] = 32'h21080002;   // addi $t0, $t0, 2
//    memory[2] = 32'b000000_10001_10100_10011_00000_100000; // add $s3, $s1, $s4
    
//    memory[0] = 32'h8e520000;

//memory[0] = 32'h0;//34040000 ; //	main:		ori	$a0, $zero, 0
//    memory[1] = 32'h0 ; //            nop
//    memory[2] = 32'h0 ; //            nop
//    memory[3] = 32'h0 ; //            nop
//    memory[4] = 32'h0 ; //            nop
//    memory[5] = 32'h0 ; //            nop
//    memory[6] = 32'h8000018 ; //            j    start
//    memory[7] = 32'h0 ; //            nop
//    memory[8] = 32'h0 ; //            nop
//    memory[9] = 32'h0 ; //            nop
//    memory[10] = 32'h0 ; //            nop
//    memory[11] = 32'h0 ; //            nop
//    memory[12] = 32'h2004000a ; //            addi    $a0, $zero, 10
//    memory[13] = 32'h0 ; //            nop
//    memory[14] = 32'h0 ; //            nop
//    memory[15] = 32'h0 ; //            nop
//    memory[16] = 32'h0 ; //            nop
//    memory[17] = 32'h0 ; //            nop
//    memory[18] = 32'h2004000a ; //            addi    $a0, $zero, 10
//    memory[19] = 32'h0 ; //            nop
//    memory[20] = 32'h0 ; //            nop
//    memory[21] = 32'h0 ; //            nop
//    memory[22] = 32'h0 ; //            nop
//    memory[23] = 32'h0 ; //            nop
//    memory[24] = 32'h8c900004 ; //    start:        lw    $s0, 4($a0)
//    memory[25] = 32'h0 ; //            nop
//    memory[26] = 32'h0 ; //            nop
//    memory[27] = 32'h0 ; //            nop
//    memory[28] = 32'h0 ; //            nop
//    memory[29] = 32'h0 ; //            nop
//    memory[30] = 32'h8c900008 ; //            lw    $s0, 8($a0)
//    memory[31] = 32'h0 ; //            nop
//    memory[32] = 32'h0 ; //            nop
//    memory[33] = 32'h0 ; //            nop
//    memory[34] = 32'h0 ; //            nop
//    memory[35] = 32'h0 ; //            nop
//    memory[36] = 32'hac900000 ; //            sw    $s0, 0($a0)
//    memory[37] = 32'h0 ; //            nop
//    memory[38] = 32'h0 ; //            nop
//    memory[39] = 32'h0 ; //            nop
//    memory[40] = 32'h0 ; //            nop
//    memory[41] = 32'h0 ; //            nop
//    memory[42] = 32'hac90000c ; //            sw    $s0, 12($a0)
//    memory[43] = 32'h0 ; //            nop
//    memory[44] = 32'h0 ; //            nop
//    memory[45] = 32'h0 ; //            nop
//    memory[46] = 32'h0 ; //            nop
//    memory[47] = 32'h0 ; //            nop
//    memory[48] = 32'h8c910000 ; //            lw    $s1, 0($a0)
//    memory[49] = 32'h0 ; //            nop
//    memory[50] = 32'h0 ; //            nop
//    memory[51] = 32'h0 ; //            nop
//    memory[52] = 32'h0 ; //            nop
//    memory[53] = 32'h0 ; //            nop
//    memory[54] = 32'h8c92000c ; //            lw    $s2, 12($a0)
//    memory[55] = 32'h0 ; //            nop
//    memory[56] = 32'h0 ; //            nop
//    memory[57] = 32'h0 ; //            nop
//    memory[58] = 32'h0 ; //            nop
//    memory[59] = 32'h0 ; //            nop
//    memory[60] = 32'h12000017 ; //            beq    $s0, $zero, branch1
//    memory[61] = 32'h0 ; //            nop
//    memory[62] = 32'h0 ; //            nop
//    memory[63] = 32'h0 ; //            nop
//    memory[64] = 32'h0 ; //            nop
//    memory[65] = 32'h0 ; //            nop
//    memory[66] = 32'h2008820 ; //            add    $s1, $s0, $zero
//    memory[67] = 32'h0 ; //            nop
//    memory[68] = 32'h0 ; //            nop
//    memory[69] = 32'h0 ; //            nop
//    memory[70] = 32'h0 ; //            nop
//    memory[71] = 32'h0 ; //            nop
//    memory[72] = 32'h1211000b ; //            beq    $s0, $s1, branch1
//    memory[73] = 32'h0 ; //            nop
//    memory[74] = 32'h0 ; //            nop
//    memory[75] = 32'h0 ; //            nop
//    memory[76] = 32'h0 ; //            nop
//    memory[77] = 32'h0 ; //            nop
//    memory[78] = 32'h8000140 ; //            j    error
//    memory[79] = 32'h0 ; //            nop
//    memory[80] = 32'h0 ; //            nop
//    memory[81] = 32'h0 ; //            nop
//    memory[82] = 32'h0 ; //            nop
//    memory[83] = 32'h0 ; //            nop
//    memory[84] = 32'h2010ffff ; //    branch1:    addi    $s0, $zero, -1
//    memory[85] = 32'h0 ; //            nop
//    memory[86] = 32'h0 ; //            nop
//    memory[87] = 32'h0 ; //            nop
//    memory[88] = 32'h0 ; //            nop
//    memory[89] = 32'h0 ; //            nop
//    memory[90] = 32'h601ffbd; //    32'h601ffbf mipshelper offset subtracted by 2            bgez    $s0, start
//    memory[91] = 32'h0 ; //            nop
//    memory[92] = 32'h0 ; //            nop
//    memory[93] = 32'h0 ; //            nop
//    memory[94] = 32'h0 ; //            nop
//    memory[95] = 32'h0 ; //            nop
//    memory[96] = 32'h22100001 ; //            addi    $s0, $s0, 1
//    memory[97] = 32'h0 ; //            nop
//    memory[98] = 32'h0 ; //            nop
//    memory[99] = 32'h0 ; //            nop
//    memory[100] = 32'h0 ; //            nop
//    memory[101] = 32'h0 ; //            nop
//    memory[102] = 32'h601000b ; //            bgez    $s0, branch2
//    memory[103] = 32'h0 ; //            nop
//    memory[104] = 32'h0 ; //            nop
//    memory[105] = 32'h0 ; //            nop
//    memory[106] = 32'h0 ; //            nop
//    memory[107] = 32'h0 ; //            nop
//    memory[108] = 32'h8000140 ; //            j    error
//    memory[109] = 32'h0 ; //            nop
//    memory[110] = 32'h0 ; //            nop
//    memory[111] = 32'h0 ; //            nop
//    memory[112] = 32'h0 ; //            nop
//    memory[113] = 32'h0 ; //            nop
//    memory[114] = 32'h2010ffff ; //    branch2:    addi    $s0, $zero, -1
//    memory[115] = 32'h0 ; //            nop
//    memory[116] = 32'h0 ; //            nop
//    memory[117] = 32'h0 ; //            nop
//    memory[118] = 32'h0 ; //            nop
//    memory[119] = 32'h0 ; //            nop
//    memory[120] = 32'h1e000019 ; //            ########### test: bgtz    $s0, branch3
//    memory[121] = 32'h0; //             nop
//    memory[122] = 32'h0 ; //            nop
//    memory[123] = 32'h0 ; //            nop
//    memory[124] = 32'h0 ; //            nop
//    memory[125] = 32'h0 ; //            nop
//    memory[126] = 32'h0 ; //            nop
//    memory[127] = 32'h20100001 ; //            addi    $s0, $zero, 1
//    memory[128] = 32'h0 ; //            nop
//    memory[129] = 32'h0 ; //            nop
//    memory[130] = 32'h0 ; //            nop
//    memory[131] = 32'h0 ; //            nop
//    memory[132] = 32'h0 ; //            nop
//    memory[133] = 32'b00011110000000000000000000001100 ; //            ######## test: bgtz    $s0, branch3
//    memory[134] = 32'h0; //             nop
//    memory[135] = 32'h0 ; //            nop
//    memory[136] = 32'h0 ; //            nop
//    memory[137] = 32'h0 ; //            nop
//    memory[138] = 32'h0 ; //            nop
//    memory[139] = 32'h0 ; //            nop
//    memory[140] = 32'h8000140 ; //            j    error
//    memory[141] = 32'h0 ; //            nop
//    memory[142] = 32'h0 ; //            nop
//    memory[143] = 32'h0 ; //            nop
//    memory[144] = 32'h0 ; //            nop
//    memory[145] = 32'h0 ; //            nop
//    memory[146] = 32'h6000017 ; //    branch3:    bltz    $s0, branch4
//    memory[147] = 32'h0 ; //            nop
//    memory[148] = 32'h0 ; //            nop
//    memory[149] = 32'h0 ; //            nop
//    memory[150] = 32'h0 ; //            nop
//    memory[151] = 32'h0 ; //            nop
//    memory[152] = 32'h2010ffff ; //            addi    $s0, $zero, -1
//    memory[153] = 32'h0 ; //            nop
//    memory[154] = 32'h0 ; //            nop
//    memory[155] = 32'h0 ; //            nop
//    memory[156] = 32'h0 ; //            nop
//    memory[157] = 32'h0 ; //            nop
//    memory[158] = 32'h600000b ; //            bltz    $s0, branch4
//    memory[159] = 32'h0 ; //            nop
//    memory[160] = 32'h0 ; //            nop
//    memory[161] = 32'h0 ; //            nop
//    memory[162] = 32'h0 ; //            nop
//    memory[163] = 32'h0 ; //            nop
//    memory[164] = 32'h8000140 ; //            j    error
//    memory[165] = 32'h0 ; //            nop
//    memory[166] = 32'h0 ; //            nop
//    memory[167] = 32'h0 ; //            nop
//    memory[168] = 32'h0 ; //            nop
//    memory[169] = 32'h0 ; //            nop
//    memory[170] = 32'h2011ffff ; //    branch4:    addi    $s1, $zero, -1
//    memory[171] = 32'h0 ; //            nop
//    memory[172] = 32'h0 ; //            nop
//    memory[173] = 32'h0 ; //            nop
//    memory[174] = 32'h0 ; //            nop
//    memory[175] = 32'h0 ; //            nop
//    memory[176] = 32'h16110011 ; //            bne    $s0, $s1, branch5
//    memory[177] = 32'h0 ; //            nop
//    memory[178] = 32'h0 ; //            nop
//    memory[179] = 32'h0 ; //            nop
//    memory[180] = 32'h0 ; //            nop
//    memory[181] = 32'h0 ; //            nop
//    memory[182] = 32'h1600000b ; //            bne    $s0, $zero, branch5
//    memory[183] = 32'h0 ; //            nop
//    memory[184] = 32'h0 ; //            nop
//    memory[185] = 32'h0 ; //            nop
//    memory[186] = 32'h0 ; //            nop
//    memory[187] = 32'h0 ; //            nop
//    memory[188] = 32'h8000140 ; //            j    error
//    memory[189] = 32'h0 ; //            nop
//    memory[190] = 32'h0 ; //            nop
//    memory[191] = 32'h0 ; //            nop
//    memory[192] = 32'h0 ; //            nop
//    memory[193] = 32'h0 ; //            nop
//    memory[194] = 32'h20100080 ; //    branch5:    addi    $s0, $zero, 128
//    memory[195] = 32'h0 ; //            nop
//    memory[196] = 32'h0 ; //            nop
//    memory[197] = 32'h0 ; //            nop
//    memory[198] = 32'h0 ; //            nop
//    memory[199] = 32'h0 ; //            nop
//    memory[200] = 32'ha0900000 ; //            sb    $s0, 0($a0)
//    memory[201] = 32'h0 ; //            nop
//    memory[202] = 32'h0 ; //            nop
//    memory[203] = 32'h0 ; //            nop
//    memory[204] = 32'h0 ; //            nop
//    memory[205] = 32'h0 ; //            nop
//    memory[206] = 32'h80900000 ; //            lb    $s0, 0($a0)
//    memory[207] = 32'h0 ; //            nop
//    memory[208] = 32'h0 ; //            nop
//    memory[209] = 32'h0 ; //            nop
//    memory[210] = 32'h0 ; //            nop
//    memory[211] = 32'h0 ; //            nop
//    memory[212] = 32'h1a00000b ; //            blez    $s0, branch6
//    memory[213] = 32'h0 ; //            nop
//    memory[214] = 32'h0 ; //            nop
//    memory[215] = 32'h0 ; //            nop
//    memory[216] = 32'h0 ; //            nop
//    memory[217] = 32'h0 ; //            nop
//    memory[218] = 32'h8000140 ; //            j    error
//    memory[219] = 32'h0 ; //            nop
//    memory[220] = 32'h0 ; //            nop
//    memory[221] = 32'h0 ; //            nop
//    memory[222] = 32'h0 ; //            nop
//    memory[223] = 32'h0 ; //            nop
//    memory[224] = 32'h2010ffff ; //    branch6:    addi    $s0, $zero, -1
//    memory[225] = 32'h0 ; //            nop
//    memory[226] = 32'h0 ; //            nop
//    memory[227] = 32'h0 ; //            nop
//    memory[228] = 32'h0 ; //            nop
//    memory[229] = 32'h0 ; //            nop
//    memory[230] = 32'ha4900000 ; //            sh    $s0, 0($a0)
//    memory[231] = 32'h0 ; //            nop
//    memory[232] = 32'h0 ; //            nop
//    memory[233] = 32'h0 ; //            nop
//    memory[234] = 32'h0 ; //            nop
//    memory[235] = 32'h0 ; //            nop
//    memory[236] = 32'h20100000 ; //            addi    $s0, $zero, 0
//    memory[237] = 32'h0 ; //            nop
//    memory[238] = 32'h0 ; //            nop
//    memory[239] = 32'h0 ; //            nop
//    memory[240] = 32'h0 ; //            nop
//    memory[241] = 32'h0 ; //            nop
//    memory[242] = 32'h84900000 ; //            lh    $s0, 0($a0)
//    memory[243] = 32'h0 ; //            nop
//    memory[244] = 32'h0 ; //            nop
//    memory[245] = 32'h0 ; //            nop
//    memory[246] = 32'h0 ; //            nop
//    memory[247] = 32'h0 ; //            nop
//    memory[248] = 32'h1a00000b ; //            blez    $s0, branch7
//    memory[249] = 32'h0 ; //            nop
//    memory[250] = 32'h0 ; //            nop
//    memory[251] = 32'h0 ; //            nop
//    memory[252] = 32'h0 ; //            nop
//    memory[253] = 32'h0 ; //            nop
//    memory[254] = 32'h8000140 ; //            j    error
//    memory[255] = 32'h0 ; //            nop
//    memory[256] = 32'h0 ; //            nop
//    memory[257] = 32'h0 ; //            nop
//    memory[258] = 32'h0 ; //            nop
//    memory[259] = 32'h0 ; //            nop
//    memory[260] = 32'h2010ffff ; //    branch7:    addi    $s0, $zero, -1
//    memory[261] = 32'h0 ; //            nop
//    memory[262] = 32'h0 ; //            nop
//    memory[263] = 32'h0 ; //            nop
//    memory[264] = 32'h0 ; //            nop
//    memory[265] = 32'h0 ; //            nop
//    memory[266] = 32'h3c100001 ; //            lui    $s0, 1
//    memory[267] = 32'h0 ; //            nop
//    memory[268] = 32'h0 ; //            nop
//    memory[269] = 32'h0 ; //            nop
//    memory[270] = 32'h0 ; //            nop
//    memory[271] = 32'h0 ; //            nop
//    memory[272] = 32'h601000b ; //            bgez    $s0, branch8
//    memory[273] = 32'h0 ; //            nop
//    memory[274] = 32'h0 ; //            nop
//    memory[275] = 32'h0 ; //            nop
//    memory[276] = 32'h0 ; //            nop
//    memory[277] = 32'h0 ; //            nop
//    memory[278] = 32'h8000140 ; //            j    error
//    memory[279] = 32'h0 ; //            nop
//    memory[280] = 32'h0 ; //            nop
//    memory[281] = 32'h0 ; //            nop
//    memory[282] = 32'h0 ; //            nop
//    memory[283] = 32'h0 ; //            nop
//    memory[284] = 32'h8000128 ; //    branch8:    j    jump1
//    memory[285] = 32'h0 ; //            nop
//    memory[286] = 32'h0 ; //            nop
//    memory[287] = 32'h0 ; //            nop
//    memory[288] = 32'h0 ; //            nop
//    memory[289] = 32'h0 ; //            nop
//    memory[290] = 32'h2210fffe ; //            addi    $s0, $s0, -2
//    memory[291] = 32'h0 ; //            nop
//    memory[292] = 32'h0 ; //            nop
//    memory[293] = 32'h0 ; //            nop
//    memory[294] = 32'h0 ; //            nop
//    memory[295] = 32'h0 ; //            nop
//    memory[296] = 32'hc000134 ; //    jump1:        jal    jal1
//    memory[297] = 32'h0 ; //            nop
//    memory[298] = 32'h0 ; //            nop
//    memory[299] = 32'h0 ; //            nop
//    memory[300] = 32'h0 ; //            nop
//    memory[301] = 32'h0 ; //            nop
//    memory[302] = 32'h8000018 ; //            j    start
//    memory[303] = 32'h0 ; //            nop
//    memory[304] = 32'h0 ; //            nop
//    memory[305] = 32'h0 ; //            nop
//    memory[306] = 32'h0 ; //            nop
//    memory[307] = 32'h0 ; //            nop
//    memory[308] = 32'h0 ; //            nop
//    memory[309] = 32'h0 ; //            nop
//    memory[310] = 32'h3e00008 ; //    jal1:        jr    $ra
//    memory[311] = 32'h0 ; //            nop
//    memory[312] = 32'h0 ; //            nop
//    memory[313] = 32'h0 ; //            nop
//    memory[314] = 32'h0 ; //            nop
//    memory[315] = 32'h0 ; //            nop
//    memory[316] = 32'h8000140 ; //            j    error
//    memory[317] = 32'h0 ; //            nop
//    memory[318] = 32'h0 ; //            nop
//    memory[319] = 32'h0 ; //            nop
//    memory[320] = 32'h0 ; //            nop
//    memory[321] = 32'h0 ; //            nop
//    memory[322] = 32'h8 ; //    error:        jr    $zero
//    memory[323] = 32'h0 ; //            nop
//    memory[324] = 32'h0 ; //            nop
//    memory[325] = 32'h0 ; //            nop
//    memory[326] = 32'h0 ; //            nop
//    memory[327] = 32'h0 ; //            nop
    
    end
    
    always @(Address) begin
        temp = Address >> 2;
        Instruction <= memory[temp]; 
        
    end

endmodule
