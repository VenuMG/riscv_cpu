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

        // ==========================================
        // INSTRUCTION FIELDS
        // ==========================================

        opcode = instruction[6:0];
        rd     = instruction[11:7];
        funct3 = instruction[14:12];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        funct7 = instruction[31:25];

        // ==========================================
        // DEFAULT VALUES
        // ==========================================

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

                3'b111: begin
                    alu_control = 3'b010;       // AND
                end

                3'b110: begin
                    alu_control = 3'b011;       // OR
                end

                3'b100: begin
                    alu_control = 3'b100;       // XOR
                end

                default: begin
                    alu_control = 3'b000;
                end

            endcase
        end

        // ==========================================
        // I-TYPE ALU INSTRUCTIONS
        // ==========================================

        else if (opcode == 7'b0010011) begin

            // Sign-extend 12-bit immediate
            immediate = {{20{instruction[31]}},
                         instruction[31:20]};

            case (funct3)

                3'b000: begin
                    alu_control = 3'b000;       // ADDI
                end

                3'b111: begin
                    alu_control = 3'b010;       // ANDI
                end

                3'b110: begin
                    alu_control = 3'b011;       // ORI
                end

                3'b100: begin
                    alu_control = 3'b100;       // XORI
                end

                default: begin
                    alu_control = 3'b000;
                end

            endcase
        end

        // ==========================================
        // S-TYPE INSTRUCTIONS
        // ==========================================

        else if (opcode == 7'b0100011) begin

            // S-type immediate:
            // imm[11:5] = instruction[31:25]
            // imm[4:0]  = instruction[11:7]

            immediate = {{20{instruction[31]}},
                         instruction[31:25],
                         instruction[11:7]};

        end

        // ==========================================
        // B-TYPE BRANCH INSTRUCTIONS
        // ==========================================

        else if (opcode == 7'b1100011) begin

            // B-type immediate:
            //
            // imm[12]   = instruction[31]
            // imm[11]   = instruction[7]
            // imm[10:5] = instruction[30:25]
            // imm[4:1]  = instruction[11:8]
            // imm[0]    = 0

            immediate = {{19{instruction[31]}},
                         instruction[31],
                         instruction[7],
                         instruction[30:25],
                         instruction[11:8],
                         1'b0};

        end

    end

endmodule