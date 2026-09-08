module control_unit (

    input logic [6:0] opcode,

    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic MemToReg,
    output logic ALUSrc,
    output logic Branch
);

    always_comb begin

        // ==========================================
        // DEFAULT VALUES
        // ==========================================

        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        ALUSrc   = 1'b0;
        Branch   = 1'b0;


        // ==========================================
        // OPCODE DECODE
        // ==========================================

        case (opcode)

            // R-TYPE
            // ADD, SUB, AND, OR, XOR
            7'b0110011: begin

                RegWrite = 1'b1;
                ALUSrc   = 1'b0;

            end


            // I-TYPE ALU
            // ADDI, ANDI, ORI, XORI
            7'b0010011: begin

                RegWrite = 1'b1;
                ALUSrc   = 1'b1;

            end


            // LOAD WORD (LW)
            7'b0000011: begin

                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemToReg = 1'b1;
                ALUSrc   = 1'b1;

            end


            // STORE WORD (SW)
            7'b0100011: begin

                MemWrite = 1'b1;
                ALUSrc   = 1'b1;

            end


            // BRANCH EQUAL (BEQ)
            7'b1100011: begin

                Branch = 1'b1;
                ALUSrc = 1'b0;

            end


            default: begin

                // Default values already assigned

            end

        endcase

    end

endmodule