module register_file (
    input logic clk,
    input logic reset,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] write_data,
    input logic reg_write,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

    // 32 registers, each 32 bits wide
    logic [31:0] registers [0:31];

    integer i;

    // ---------------------------------------------------------
    // Register Write / Reset Logic
    // ---------------------------------------------------------
    always_ff @(posedge clk) begin

        if (reset) begin

            // Reset all registers
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;

        end

        else if (reg_write && (rd != 5'b00000)) begin

            // x0 cannot be written
            registers[rd] <= write_data;

        end

    end


    // ---------------------------------------------------------
    // Combinational Register Reads
    // ---------------------------------------------------------
    always_comb begin

        // x0 always reads as zero
        if (rs1 == 5'b00000)
            read_data1 = 32'b0;
        else
            read_data1 = registers[rs1];


        if (rs2 == 5'b00000)
            read_data2 = 32'b0;
        else
            read_data2 = registers[rs2];

    end


    // ---------------------------------------------------------
    // DAY 14 ASSERTION
    // RISC-V x0 must always contain zero
    // ---------------------------------------------------------
    `ifndef SYNTHESIS

    always_ff @(posedge clk) begin

        if (!reset) begin

            assert (registers[0] == 32'b0)
                else $error(
                    "ASSERTION FAILED: x0 is not zero"
                );

        end

    end

    `endif

endmodule