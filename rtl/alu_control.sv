module alu_control (

    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,

    output logic [2:0] alu_control

);

    always_comb begin

        // ==========================================
        // DEFAULT
        // ==========================================

        alu_control = 3'b000;


        // ==========================================
        // R-TYPE
        // ==========================================

        if (opcode == 7'b0110011) begin

            case (funct3)

                // ADD / SUB
                3'b000: begin

                    if (funct7 == 7'b0100000)
                        alu_control = 3'b001;   // SUB
                    else
                        alu_control = 3'b000;   // ADD

                end

                // AND
                3'b111: begin
                    alu_control = 3'b010;
                end

                // OR
                3'b110: begin
                    alu_control = 3'b011;
                end

                // XOR
                3'b100: begin
                    alu_control = 3'b100;
                end

                default: begin
                    alu_control = 3'b000;
                end

            endcase

        end


        // ==========================================
        // I-TYPE ALU
        // ==========================================

        else if (opcode == 7'b0010011) begin

            case (funct3)

                // ADDI
                3'b000: begin
                    alu_control = 3'b000;
                end

                // ANDI
                3'b111: begin
                    alu_control = 3'b010;
                end

                // ORI
                3'b110: begin
                    alu_control = 3'b011;
                end

                // XORI
                3'b100: begin
                    alu_control = 3'b100;
                end

                default: begin
                    alu_control = 3'b000;
                end

            endcase

        end


        // ==========================================
        // LOAD / STORE
        // ==========================================

        else if (opcode == 7'b0000011 ||
                 opcode == 7'b0100011) begin

            // Address calculation:
            // base register + immediate

            alu_control = 3'b000;

        end


        // ==========================================
        // BRANCH
        // ==========================================

        else if (opcode == 7'b1100011) begin

            // BEQ requires subtraction:
            // rs1 - rs2 = 0 → branch taken

            alu_control = 3'b001;

        end

    end

endmodule