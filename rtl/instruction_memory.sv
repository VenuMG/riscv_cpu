module instruction_memory (
    input logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255];

    initial begin

        memory[0] = 32'h00A00093; // ADDI x1, x0, 10
        memory[1] = 32'h01400113; // ADDI x2, x0, 20
        memory[2] = 32'h002081B3; // ADD  x3, x1, x2
        memory[3] = 32'h40110233; // SUB  x4, x2, x1
        memory[4] = 32'h0020F2B3; // AND  x5, x1, x2
        memory[5] = 32'h0020E333; // OR   x6, x1, x2
        memory[6] = 32'h0020C3B3; // XOR  x7, x1, x2

        // Fill remaining memory with NOPs
        for (integer i = 7; i < 256; i = i + 1)
            memory[i] = 32'h00000013;

    end

    always_comb begin
        instruction = memory[address[9:2]];
    end

endmodule
