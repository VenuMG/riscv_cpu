module instruction_memory (
    input logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255];

    always_comb begin
        instruction = memory[address[9:2]];
    end

    initial begin
        memory[0] = 32'h40E305B3; // PC=0 SUB x11, x6, x14
        memory[1] = 32'hFADFC713; // PC=4 XORI x14, x31, -83
        memory[2] = 32'h00728A33; // PC=8 ADD x20, x5, x7
        memory[3] = 32'h01C34DB3; // PC=12 XOR x27, x6, x28
        memory[4] = 32'h014F8DB3; // PC=16 ADD x27, x31, x20
        memory[5] = 32'h016866B3; // PC=20 OR x13, x16, x22
        memory[6] = 32'h2E4C0D13; // PC=24 ADDI x26, x24, 740
        memory[7] = 32'h41290933; // PC=28 SUB x18, x18, x18
        memory[8] = 32'h3CD9E293; // PC=32 ORI x5, x19, 973
        memory[9] = 32'h4C2D8793; // PC=36 ADDI x15, x27, 1218
        memory[10] = 32'h7B63C813; // PC=40 XORI x16, x7, 1974
        memory[11] = 32'h75587F13; // PC=44 ANDI x30, x16, 1877
        memory[12] = 32'hC200C893; // PC=48 XORI x17, x1, -992
        memory[13] = 32'h01B30FB3; // PC=52 ADD x31, x6, x27
        memory[14] = 32'hBE7F6293; // PC=56 ORI x5, x30, -1049
        memory[15] = 32'h4DDF6B13; // PC=60 ORI x22, x30, 1245
        memory[16] = 32'h019F4933; // PC=64 XOR x18, x30, x25
        memory[17] = 32'h84B97393; // PC=68 ANDI x7, x18, -1973
        memory[18] = 32'h01FE82B3; // PC=72 ADD x5, x29, x31
        memory[19] = 32'h78960F13; // PC=76 ADDI x30, x12, 1929
        memory[20] = 32'h913FE893; // PC=80 ORI x17, x31, -1773
        memory[21] = 32'h006EC5B3; // PC=84 XOR x11, x29, x6
        memory[22] = 32'hDDB86B93; // PC=88 ORI x23, x16, -549
        memory[23] = 32'h086F7D93; // PC=92 ANDI x27, x30, 134
        memory[24] = 32'h52936613; // PC=96 ORI x12, x6, 1321
        memory[25] = 32'h005077B3; // PC=100 AND x15, x0, x5
        memory[26] = 32'h00C287B3; // PC=104 ADD x15, x5, x12
        memory[27] = 32'h01116233; // PC=108 OR x4, x2, x17
        memory[28] = 32'h7BE00293; // PC=112 ADDI x5, x0, 1982
        memory[29] = 32'h01E77933; // PC=116 AND x18, x14, x30
        memory[30] = 32'h00597FB3; // PC=120 AND x31, x18, x5
        memory[31] = 32'h1CA57B13; // PC=124 ANDI x22, x10, 458
        memory[32] = 32'hE4BC4713; // PC=128 XORI x14, x24, -437
        memory[33] = 32'hA5937093; // PC=132 ANDI x1, x6, -1447
        memory[34] = 32'h016B0DB3; // PC=136 ADD x27, x22, x22
        memory[35] = 32'h014F00B3; // PC=140 ADD x1, x30, x20
        memory[36] = 32'h007A47B3; // PC=144 XOR x15, x20, x7
        memory[37] = 32'hCECEEF93; // PC=148 ORI x31, x29, -788
        memory[38] = 32'h6AEDC393; // PC=152 XORI x7, x27, 1710
        memory[39] = 32'h01926B33; // PC=156 OR x22, x4, x25
        memory[40] = 32'h002583B3; // PC=160 ADD x7, x11, x2
        memory[41] = 32'hE081CF13; // PC=164 XORI x30, x3, -504
        memory[42] = 32'hEFF0EB93; // PC=168 ORI x23, x1, -257
        memory[43] = 32'hDF344E93; // PC=172 XORI x29, x8, -525
        memory[44] = 32'hA84DF493; // PC=176 ANDI x9, x27, -1404
        memory[45] = 32'hD975F513; // PC=180 ANDI x10, x11, -617
        memory[46] = 32'h01AFC7B3; // PC=184 XOR x15, x31, x26
        memory[47] = 32'h0145C7B3; // PC=188 XOR x15, x11, x20
        memory[48] = 32'h0C3E4813; // PC=192 XORI x16, x28, 195
        memory[49] = 32'h40E68E33; // PC=196 SUB x28, x13, x14
        memory[50] = 32'h01D28FB3; // PC=200 ADD x31, x5, x29
        memory[51] = 32'h34358713; // PC=204 ADDI x14, x11, 835
        memory[52] = 32'h0076F633; // PC=208 AND x12, x13, x7
        memory[53] = 32'h0126C933; // PC=212 XOR x18, x13, x18
        memory[54] = 32'h00644B33; // PC=216 XOR x22, x8, x6
        memory[55] = 32'h00ADC233; // PC=220 XOR x4, x27, x10
        memory[56] = 32'h41618B33; // PC=224 SUB x22, x3, x22
        memory[57] = 32'h01437AB3; // PC=228 AND x21, x6, x20
        memory[58] = 32'h012249B3; // PC=232 XOR x19, x4, x18
        memory[59] = 32'hA0380313; // PC=236 ADDI x6, x16, -1533
        memory[60] = 32'h01A80733; // PC=240 ADD x14, x16, x26
        memory[61] = 32'h00F30133; // PC=244 ADD x2, x6, x15
        memory[62] = 32'h00638533; // PC=248 ADD x10, x7, x6
        memory[63] = 32'h697B4993; // PC=252 XORI x19, x22, 1687
        memory[64] = 32'h014C8F33; // PC=256 ADD x30, x25, x20
        memory[65] = 32'h01BEEA33; // PC=260 OR x20, x29, x27
        memory[66] = 32'h410B8B33; // PC=264 SUB x22, x23, x16
        memory[67] = 32'h5F9B7513; // PC=268 ANDI x10, x22, 1529
        memory[68] = 32'h012A8533; // PC=272 ADD x10, x21, x18
        memory[69] = 32'h414D0533; // PC=276 SUB x10, x26, x20
        memory[70] = 32'h00CA8933; // PC=280 ADD x18, x21, x12
        memory[71] = 32'hBED3C113; // PC=284 XORI x2, x7, -1043
        memory[72] = 32'h41640133; // PC=288 SUB x2, x8, x22
        memory[73] = 32'h008DC0B3; // PC=292 XOR x1, x27, x8
        memory[74] = 32'hFA8C0713; // PC=296 ADDI x14, x24, -88
        memory[75] = 32'hDDE77B13; // PC=300 ANDI x22, x14, -546
        memory[76] = 32'hCB9CC093; // PC=304 XORI x1, x25, -839
        memory[77] = 32'h0110E0B3; // PC=308 OR x1, x1, x17
        memory[78] = 32'h212D4813; // PC=312 XORI x16, x26, 530
        memory[79] = 32'h00B2FFB3; // PC=316 AND x31, x5, x11
        memory[80] = 32'h22884113; // PC=320 XORI x2, x16, 552
        memory[81] = 32'h00F00B33; // PC=324 ADD x22, x0, x15
        memory[82] = 32'h4C576113; // PC=328 ORI x2, x14, 1221
        memory[83] = 32'h2FF70F93; // PC=332 ADDI x31, x14, 767
        memory[84] = 32'h01DB6633; // PC=336 OR x12, x22, x29
        memory[85] = 32'hE03F6913; // PC=340 ORI x18, x30, -509
        memory[86] = 32'h009D7AB3; // PC=344 AND x21, x26, x9
        memory[87] = 32'h51106E93; // PC=348 ORI x29, x0, 1297
        memory[88] = 32'h00558AB3; // PC=352 ADD x21, x11, x5
        memory[89] = 32'h00884633; // PC=356 XOR x12, x16, x8
        memory[90] = 32'h40D08EB3; // PC=360 SUB x29, x1, x13
        memory[91] = 32'h019149B3; // PC=364 XOR x19, x2, x25
        memory[92] = 32'hABC57913; // PC=368 ANDI x18, x10, -1348
        memory[93] = 32'h015C7C33; // PC=372 AND x24, x24, x21
        memory[94] = 32'hE129C493; // PC=376 XORI x9, x19, -494
        memory[95] = 32'h01297EB3; // PC=380 AND x29, x18, x18
        memory[96] = 32'h46FB4513; // PC=384 XORI x10, x22, 1135
        memory[97] = 32'h01E06C33; // PC=388 OR x24, x0, x30
        memory[98] = 32'hDBF57613; // PC=392 ANDI x12, x10, -577
        memory[99] = 32'h8E848913; // PC=396 ADDI x18, x9, -1816
        memory[100] = 32'h00000013;
        memory[101] = 32'h00000013;
        memory[102] = 32'h00000013;
        memory[103] = 32'h00000013;
        memory[104] = 32'h00000013;
        memory[105] = 32'h00000013;
        memory[106] = 32'h00000013;
        memory[107] = 32'h00000013;
        memory[108] = 32'h00000013;
        memory[109] = 32'h00000013;
        memory[110] = 32'h00000013;
        memory[111] = 32'h00000013;
        memory[112] = 32'h00000013;
        memory[113] = 32'h00000013;
        memory[114] = 32'h00000013;
        memory[115] = 32'h00000013;
        memory[116] = 32'h00000013;
        memory[117] = 32'h00000013;
        memory[118] = 32'h00000013;
        memory[119] = 32'h00000013;
        memory[120] = 32'h00000013;
        memory[121] = 32'h00000013;
        memory[122] = 32'h00000013;
        memory[123] = 32'h00000013;
        memory[124] = 32'h00000013;
        memory[125] = 32'h00000013;
        memory[126] = 32'h00000013;
        memory[127] = 32'h00000013;
        memory[128] = 32'h00000013;
        memory[129] = 32'h00000013;
        memory[130] = 32'h00000013;
        memory[131] = 32'h00000013;
        memory[132] = 32'h00000013;
        memory[133] = 32'h00000013;
        memory[134] = 32'h00000013;
        memory[135] = 32'h00000013;
        memory[136] = 32'h00000013;
        memory[137] = 32'h00000013;
        memory[138] = 32'h00000013;
        memory[139] = 32'h00000013;
        memory[140] = 32'h00000013;
        memory[141] = 32'h00000013;
        memory[142] = 32'h00000013;
        memory[143] = 32'h00000013;
        memory[144] = 32'h00000013;
        memory[145] = 32'h00000013;
        memory[146] = 32'h00000013;
        memory[147] = 32'h00000013;
        memory[148] = 32'h00000013;
        memory[149] = 32'h00000013;
        memory[150] = 32'h00000013;
        memory[151] = 32'h00000013;
        memory[152] = 32'h00000013;
        memory[153] = 32'h00000013;
        memory[154] = 32'h00000013;
        memory[155] = 32'h00000013;
        memory[156] = 32'h00000013;
        memory[157] = 32'h00000013;
        memory[158] = 32'h00000013;
        memory[159] = 32'h00000013;
        memory[160] = 32'h00000013;
        memory[161] = 32'h00000013;
        memory[162] = 32'h00000013;
        memory[163] = 32'h00000013;
        memory[164] = 32'h00000013;
        memory[165] = 32'h00000013;
        memory[166] = 32'h00000013;
        memory[167] = 32'h00000013;
        memory[168] = 32'h00000013;
        memory[169] = 32'h00000013;
        memory[170] = 32'h00000013;
        memory[171] = 32'h00000013;
        memory[172] = 32'h00000013;
        memory[173] = 32'h00000013;
        memory[174] = 32'h00000013;
        memory[175] = 32'h00000013;
        memory[176] = 32'h00000013;
        memory[177] = 32'h00000013;
        memory[178] = 32'h00000013;
        memory[179] = 32'h00000013;
        memory[180] = 32'h00000013;
        memory[181] = 32'h00000013;
        memory[182] = 32'h00000013;
        memory[183] = 32'h00000013;
        memory[184] = 32'h00000013;
        memory[185] = 32'h00000013;
        memory[186] = 32'h00000013;
        memory[187] = 32'h00000013;
        memory[188] = 32'h00000013;
        memory[189] = 32'h00000013;
        memory[190] = 32'h00000013;
        memory[191] = 32'h00000013;
        memory[192] = 32'h00000013;
        memory[193] = 32'h00000013;
        memory[194] = 32'h00000013;
        memory[195] = 32'h00000013;
        memory[196] = 32'h00000013;
        memory[197] = 32'h00000013;
        memory[198] = 32'h00000013;
        memory[199] = 32'h00000013;
        memory[200] = 32'h00000013;
        memory[201] = 32'h00000013;
        memory[202] = 32'h00000013;
        memory[203] = 32'h00000013;
        memory[204] = 32'h00000013;
        memory[205] = 32'h00000013;
        memory[206] = 32'h00000013;
        memory[207] = 32'h00000013;
        memory[208] = 32'h00000013;
        memory[209] = 32'h00000013;
        memory[210] = 32'h00000013;
        memory[211] = 32'h00000013;
        memory[212] = 32'h00000013;
        memory[213] = 32'h00000013;
        memory[214] = 32'h00000013;
        memory[215] = 32'h00000013;
        memory[216] = 32'h00000013;
        memory[217] = 32'h00000013;
        memory[218] = 32'h00000013;
        memory[219] = 32'h00000013;
        memory[220] = 32'h00000013;
        memory[221] = 32'h00000013;
        memory[222] = 32'h00000013;
        memory[223] = 32'h00000013;
        memory[224] = 32'h00000013;
        memory[225] = 32'h00000013;
        memory[226] = 32'h00000013;
        memory[227] = 32'h00000013;
        memory[228] = 32'h00000013;
        memory[229] = 32'h00000013;
        memory[230] = 32'h00000013;
        memory[231] = 32'h00000013;
        memory[232] = 32'h00000013;
        memory[233] = 32'h00000013;
        memory[234] = 32'h00000013;
        memory[235] = 32'h00000013;
        memory[236] = 32'h00000013;
        memory[237] = 32'h00000013;
        memory[238] = 32'h00000013;
        memory[239] = 32'h00000013;
        memory[240] = 32'h00000013;
        memory[241] = 32'h00000013;
        memory[242] = 32'h00000013;
        memory[243] = 32'h00000013;
        memory[244] = 32'h00000013;
        memory[245] = 32'h00000013;
        memory[246] = 32'h00000013;
        memory[247] = 32'h00000013;
        memory[248] = 32'h00000013;
        memory[249] = 32'h00000013;
        memory[250] = 32'h00000013;
        memory[251] = 32'h00000013;
        memory[252] = 32'h00000013;
        memory[253] = 32'h00000013;
        memory[254] = 32'h00000013;
        memory[255] = 32'h00000013;
    end
endmodule
