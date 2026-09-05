module instruction_memory (
    input  logic [31:0] address,

    output logic [31:0] instruction
);

    logic [31:0] memory [0:63];

    initial begin

        memory[0] = 32'h00500093;
        memory[1] = 32'h00A00113;
        memory[2] = 32'h002081B3;
        memory[3] = 32'h00310023;

        memory[4] = 32'h00000013;
        memory[5] = 32'h00000013;
        memory[6] = 32'h00000013;
        memory[7] = 32'h00000013;

    end

    always_comb begin
        instruction = memory[address[7:2]];
    end

endmodule