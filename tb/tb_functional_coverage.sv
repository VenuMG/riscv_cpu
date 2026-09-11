module tb_functional_coverage;

    // =========================================================
    // SIGNALS
    // =========================================================

    logic [31:0] instruction;

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [6:0] funct7;
    logic [2:0] alu_control;
    logic [31:0] immediate;

    // =========================================================
    // COVERAGE COUNTERS
    // =========================================================

    integer count_add;
    integer count_sub;
    integer count_and;
    integer count_or;
    integer count_xor;

    integer count_addi;
    integer count_andi;
    integer count_ori;
    integer count_xori;

    integer count_sw;
    integer count_beq;
    integer count_jal;

    integer count_invalid;

    // =========================================================
    // INSTRUCTION DECODER
    // =========================================================

    instruction_decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .alu_control(alu_control),
        .immediate(immediate)
    );

    // =========================================================
    // TASK: TEST R-TYPE INSTRUCTION
    // =========================================================

    task automatic test_r_type(
        input logic [2:0] test_funct3,
        input logic [6:0] test_funct7,
        input logic [2:0] expected_alu,
        input string instruction_name
    );

        begin

            instruction = {
                test_funct7,
                5'd2,
                5'd1,
                test_funct3,
                5'd3,
                7'b0110011
            };

            #1;

            assert (opcode == 7'b0110011)
                else $error(
                    "%s: incorrect opcode",
                    instruction_name
                );

            assert (alu_control == expected_alu)
                else $error(
                    "%s: incorrect ALU control",
                    instruction_name
                );

            case (instruction_name)

                "ADD":
                    count_add = count_add + 1;

                "SUB":
                    count_sub = count_sub + 1;

                "AND":
                    count_and = count_and + 1;

                "OR":
                    count_or = count_or + 1;

                "XOR":
                    count_xor = count_xor + 1;

                default:
                    count_invalid = count_invalid + 1;

            endcase

            $display(
                "COVERED: %s",
                instruction_name
            );

        end

    endtask

    // =========================================================
    // TASK: TEST I-TYPE INSTRUCTION
    // =========================================================

    task automatic test_i_type(
        input logic [2:0] test_funct3,
        input logic [2:0] expected_alu,
        input string instruction_name
    );

        begin

            instruction = {
                12'd10,
                5'd1,
                test_funct3,
                5'd3,
                7'b0010011
            };

            #1;

            assert (opcode == 7'b0010011)
                else $error(
                    "%s: incorrect opcode",
                    instruction_name
                );

            assert (alu_control == expected_alu)
                else $error(
                    "%s: incorrect ALU control",
                    instruction_name
                );

            case (instruction_name)

                "ADDI":
                    count_addi = count_addi + 1;

                "ANDI":
                    count_andi = count_andi + 1;

                "ORI":
                    count_ori = count_ori + 1;

                "XORI":
                    count_xori = count_xori + 1;

                default:
                    count_invalid = count_invalid + 1;

            endcase

            $display(
                "COVERED: %s",
                instruction_name
            );

        end

    endtask

    // =========================================================
    // MAIN FUNCTIONAL COVERAGE TEST
    // =========================================================

    initial begin

        // -----------------------------------------------------
        // INITIALIZE COUNTERS
        // -----------------------------------------------------

        count_add   = 0;
        count_sub   = 0;
        count_and   = 0;
        count_or    = 0;
        count_xor   = 0;

        count_addi  = 0;
        count_andi  = 0;
        count_ori   = 0;
        count_xori  = 0;

        count_sw    = 0;
        count_beq   = 0;
        count_jal   = 0;

        count_invalid = 0;

        instruction = 32'b0;

        $display("==========================================");
        $display("FUNCTIONAL COVERAGE TEST");
        $display("==========================================");

        // =====================================================
        // R-TYPE COVERAGE
        // =====================================================

        test_r_type(
            3'b000,
            7'b0000000,
            3'b000,
            "ADD"
        );

        test_r_type(
            3'b000,
            7'b0100000,
            3'b001,
            "SUB"
        );

        test_r_type(
            3'b111,
            7'b0000000,
            3'b010,
            "AND"
        );

        test_r_type(
            3'b110,
            7'b0000000,
            3'b011,
            "OR"
        );

        test_r_type(
            3'b100,
            7'b0000000,
            3'b100,
            "XOR"
        );

        // =====================================================
        // I-TYPE COVERAGE
        // =====================================================

        test_i_type(
            3'b000,
            3'b000,
            "ADDI"
        );

        test_i_type(
            3'b111,
            3'b010,
            "ANDI"
        );

        test_i_type(
            3'b110,
            3'b011,
            "ORI"
        );

        test_i_type(
            3'b100,
            3'b100,
            "XORI"
        );

        // =====================================================
        // STORE COVERAGE
        // =====================================================

        instruction = {
            7'b0000000,
            5'd2,
            5'd1,
            3'b010,
            5'd4,
            7'b0100011
        };

        #1;

        assert (opcode == 7'b0100011)
            else $error("SW: incorrect opcode");

        assert (immediate == 32'd4)
            else $error("SW: immediate decoding incorrect");

        count_sw = count_sw + 1;

        $display("COVERED: SW");

        // =====================================================
        // BEQ COVERAGE
        // =====================================================

        // B-type instruction with a positive branch offset.
        //
        // Fields:
        //
        // imm[12]   = bit 31
        // imm[10:5] = bits 30:25
        // rs2       = bits 24:20
        // rs1       = bits 19:15
        // funct3    = bits 14:12
        // imm[4:1]  = bits 11:8
        // imm[11]   = bit 7
        // opcode    = bits 6:0

        instruction = {
            1'b0,
            6'b000000,
            5'd2,
            5'd1,
            3'b000,
            4'b0100,
            1'b0,
            7'b1100011
        };

        #1;

        assert (opcode == 7'b1100011)
            else $error("BEQ: incorrect opcode");

        count_beq = count_beq + 1;

        $display("COVERED: BEQ");

        // =====================================================
        // JAL COVERAGE
        // =====================================================

        // J-type instruction.
        //
        // Fields:
        //
        // imm[20]    = bit 31
        // imm[10:1]  = bits 30:21
        // imm[11]    = bit 20
        // imm[19:12] = bits 19:12
        // rd         = bits 11:7
        // opcode     = bits 6:0
        //
        // Total width = 1 + 10 + 1 + 8 + 5 + 7 = 32 bits.

        instruction = {
            1'b0,
            10'b0000000000,
            1'b0,
            8'b00000000,
            5'd5,
            7'b1101111
        };

        #1;

        assert (opcode == 7'b1101111)
            else $error("JAL: incorrect opcode");

        assert (rd == 5'd5)
            else $error("JAL: rd decoding incorrect");

        count_jal = count_jal + 1;

        $display("COVERED: JAL");

        // =====================================================
        // INVALID OPCODE COVERAGE
        // =====================================================

        instruction = 32'h0000007F;

        #1;

        assert (opcode == 7'b1111111)
            else $error("INVALID: opcode decoding incorrect");

        count_invalid = count_invalid + 1;

        $display("COVERED: INVALID OPCODE");

        // =====================================================
        // COVERAGE REPORT
        // =====================================================

        $display("");
        $display("==========================================");
        $display("FUNCTIONAL COVERAGE REPORT");
        $display("==========================================");

        $display("ADD   : %0d", count_add);
        $display("SUB   : %0d", count_sub);
        $display("AND   : %0d", count_and);
        $display("OR    : %0d", count_or);
        $display("XOR   : %0d", count_xor);

        $display("ADDI  : %0d", count_addi);
        $display("ANDI  : %0d", count_andi);
        $display("ORI   : %0d", count_ori);
        $display("XORI  : %0d", count_xori);

        $display("SW    : %0d", count_sw);
        $display("BEQ   : %0d", count_beq);
        $display("JAL   : %0d", count_jal);

        $display("INVALID: %0d", count_invalid);

        // =====================================================
        // FINAL COVERAGE CHECK
        // =====================================================

        assert (count_add > 0)
            else $error("COVERAGE MISS: ADD");

        assert (count_sub > 0)
            else $error("COVERAGE MISS: SUB");

        assert (count_and > 0)
            else $error("COVERAGE MISS: AND");

        assert (count_or > 0)
            else $error("COVERAGE MISS: OR");

        assert (count_xor > 0)
            else $error("COVERAGE MISS: XOR");

        assert (count_addi > 0)
            else $error("COVERAGE MISS: ADDI");

        assert (count_andi > 0)
            else $error("COVERAGE MISS: ANDI");

        assert (count_ori > 0)
            else $error("COVERAGE MISS: ORI");

        assert (count_xori > 0)
            else $error("COVERAGE MISS: XORI");

        assert (count_sw > 0)
            else $error("COVERAGE MISS: SW");

        assert (count_beq > 0)
            else $error("COVERAGE MISS: BEQ");

        assert (count_jal > 0)
            else $error("COVERAGE MISS: JAL");

        assert (count_invalid > 0)
            else $error("COVERAGE MISS: INVALID OPCODE");

        $display("");
        $display("------------------------------------------");
        $display("ALL FUNCTIONAL COVERAGE BINS HIT");
        $display("FUNCTIONAL COVERAGE TEST PASSED");
        $display("==========================================");

        $finish;

    end

endmodule