module instruction_decoder (
    input  logic [31:0] instruction,

    output logic [6:0]  opcode,
    output logic [4:0]  rd,
    output logic [2:0]  funct3,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [6:0]  funct7,

    output logic [2:0]  alu_control,
    output logic [31:0] immediate
);

    always_comb begin

        // Instruction fields
        opcode = instruction[6:0];
        rd     = instruction[11:7];
        funct3 = instruction[14:12];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        funct7 = instruction[31:25];

        // Default values
        alu_control = 3'b000;
        immediate   = 32'b0;

        // ==========================================
        // R-TYPE INSTRUCTIONS
        // ==========================================
        if (opcode == 7'b0110011) begin

            case (funct3)

                3'b000: begin
                    if (funct7 == 7'b0100000)
                        alu_control = 3'b001;   // SUB
                    else
                        alu_control = 3'b000;   // ADD
                end

                3'b111:
                    alu_control = 3'b010;       // AND

                3'b110:
                    alu_control = 3'b011;       // OR

                3'b100:
                    alu_control = 3'b100;       // XOR

                default:
                    alu_control = 3'b000;

            endcase
        end

        // ==========================================
        // I-TYPE ALU INSTRUCTIONS
        // ==========================================
        else if (opcode == 7'b0010011) begin

            // Sign-extend 12-bit immediate
            immediate = {{20{instruction[31]}}, instruction[31:20]};

            case (funct3)

                3'b000:
                    alu_control = 3'b000;       // ADDI

                3'b111:
                    alu_control = 3'b010;       // ANDI

                3'b110:
                    alu_control = 3'b011;       // ORI

                3'b100:
                    alu_control = 3'b100;       // XORI

                default:
                    alu_control = 3'b000;

            endcase
        end

    end

endmodule