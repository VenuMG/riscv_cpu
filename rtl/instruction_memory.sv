module instruction_memory (
    input logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:63];

    initial begin

        // ========================================================
        // DAY 8 LOAD / STORE TEST
        // ========================================================

        // PC = 0
        // ADDI x1, x0, 100
        //
        // x1 = 100
        memory[0] = 32'h06400093;


        // PC = 4
        // SW x1, 0(x0)
        //
        // memory[0] = 100
        memory[1] = 32'h00102023;


        // PC = 8
        // LW x2, 0(x0)
        //
        // x2 = memory[0]
        // x2 = 100
        memory[2] = 32'h00002103;


        // PC = 12
        // ADD x3, x1, x2
        //
        // x3 = 100 + 100
        // x3 = 200
        memory[3] = 32'h002081B3;


        // PC = 16
        // SW x3, 4(x0)
        //
        // memory[1] = 200
        memory[4] = 32'h00302223;


        // PC = 20
        // LW x4, 4(x0)
        //
        // x4 = 200
        memory[5] = 32'h00402203;


        // PC = 24
        // NOP
        memory[6] = 32'h00000013;


        // PC = 28
        // NOP
        memory[7] = 32'h00000013;


        // Remaining memory = NOP
        memory[8]  = 32'h00000013;
        memory[9]  = 32'h00000013;
        memory[10] = 32'h00000013;
        memory[11] = 32'h00000013;

    end


    always_comb begin

        instruction = memory[address[7:2]];

    end

endmodule