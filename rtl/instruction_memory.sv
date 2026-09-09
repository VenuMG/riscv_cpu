module instruction_memory (
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255];

    always_comb begin
        instruction = memory[address[9:2]];
    end

    initial begin

        // ==========================================
        // DAY 11 DIFFERENTIAL VERIFICATION PROGRAM
        // ==========================================

        // PC 0
        // ADDI x1, x0, 10
        memory[0] = 32'h00A00093;

        // PC 4
        // ADDI x2, x0, 20
        memory[1] = 32'h01400113;

        // PC 8
        // ADD x3, x1, x2
        memory[2] = 32'h002081B3;

        // PC 12
        // SW x3, 0(x0)
        memory[3] = 32'h00302023;

        // PC 16
        // LW x8, 0(x0)
        memory[4] = 32'h00002403;

        // PC 20
        // BEQ x3, x8, +8
        memory[5] = 32'h00818463;

        // PC 24
        // ADDI x9, x0, 99
        // This instruction must be skipped.
        memory[6] = 32'h06300493;

        // PC 28
        // ADDI x9, x0, 55
        memory[7] = 32'h03700493;

        // PC 32
        // JAL x10, +8
        memory[8] = 32'h0080056F;

        // PC 36
        // ADDI x11, x0, 99
        // This instruction must be skipped.
        memory[9] = 32'h06300593;

        // PC 40
        // ADDI x11, x0, 77
        memory[10] = 32'h04D00593;

        // ==========================================
        // NOPs
        // ==========================================

        memory[11] = 32'h00000013;
        memory[12] = 32'h00000013;
        memory[13] = 32'h00000013;
        memory[14] = 32'h00000013;
        memory[15] = 32'h00000013;

    end

endmodule