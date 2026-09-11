module tb_control_assert;

    // =========================================================
    // SIGNALS
    // =========================================================

    logic [6:0] opcode;

    logic RegWrite;
    logic MemRead;
    logic MemWrite;
    logic MemToReg;
    logic ALUSrc;
    logic Branch;

    // =========================================================
    // CONTROL UNIT
    // =========================================================

    control_unit dut (
        .opcode(opcode),

        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch)
    );

    // =========================================================
    // TEST
    // =========================================================

    initial begin

        $display("==========================================");
        $display("CONTROL UNIT ASSERTION TEST");
        $display("==========================================");

        // =====================================================
        // R-TYPE
        // opcode = 0110011
        // =====================================================

        opcode = 7'b0110011;

        #1;

        assert (RegWrite == 1'b1)
            else $error("R-TYPE: RegWrite incorrect");

        assert (MemRead == 1'b0)
            else $error("R-TYPE: MemRead incorrect");

        assert (MemWrite == 1'b0)
            else $error("R-TYPE: MemWrite incorrect");

        assert (MemToReg == 1'b0)
            else $error("R-TYPE: MemToReg incorrect");

        assert (ALUSrc == 1'b0)
            else $error("R-TYPE: ALUSrc incorrect");

        assert (Branch == 1'b0)
            else $error("R-TYPE: Branch incorrect");

        $display("R-TYPE CONTROL PASS");


        // =====================================================
        // I-TYPE
        // opcode = 0010011
        // =====================================================

        opcode = 7'b0010011;

        #1;

        assert (RegWrite == 1'b1)
            else $error("I-TYPE: RegWrite incorrect");

        assert (MemRead == 1'b0)
            else $error("I-TYPE: MemRead incorrect");

        assert (MemWrite == 1'b0)
            else $error("I-TYPE: MemWrite incorrect");

        assert (MemToReg == 1'b0)
            else $error("I-TYPE: MemToReg incorrect");

        assert (ALUSrc == 1'b1)
            else $error("I-TYPE: ALUSrc incorrect");

        assert (Branch == 1'b0)
            else $error("I-TYPE: Branch incorrect");

        $display("I-TYPE CONTROL PASS");


        // =====================================================
        // LOAD
        // opcode = 0000011
        // =====================================================

        opcode = 7'b0000011;

        #1;

        assert (RegWrite == 1'b1)
            else $error("LOAD: RegWrite incorrect");

        assert (MemRead == 1'b1)
            else $error("LOAD: MemRead incorrect");

        assert (MemWrite == 1'b0)
            else $error("LOAD: MemWrite incorrect");

        assert (MemToReg == 1'b1)
            else $error("LOAD: MemToReg incorrect");

        assert (ALUSrc == 1'b1)
            else $error("LOAD: ALUSrc incorrect");

        assert (Branch == 1'b0)
            else $error("LOAD: Branch incorrect");

        $display("LOAD CONTROL PASS");


        // =====================================================
        // STORE
        // opcode = 0100011
        // =====================================================

        opcode = 7'b0100011;

        #1;

        assert (RegWrite == 1'b0)
            else $error("STORE: RegWrite incorrect");

        assert (MemRead == 1'b0)
            else $error("STORE: MemRead incorrect");

        assert (MemWrite == 1'b1)
            else $error("STORE: MemWrite incorrect");

        assert (MemToReg == 1'b0)
            else $error("STORE: MemToReg incorrect");

        assert (ALUSrc == 1'b1)
            else $error("STORE: ALUSrc incorrect");

        assert (Branch == 1'b0)
            else $error("STORE: Branch incorrect");

        $display("STORE CONTROL PASS");


        // =====================================================
        // BEQ
        // opcode = 1100011
        // =====================================================

        opcode = 7'b1100011;

        #1;

        assert (RegWrite == 1'b0)
            else $error("BEQ: RegWrite incorrect");

        assert (MemRead == 1'b0)
            else $error("BEQ: MemRead incorrect");

        assert (MemWrite == 1'b0)
            else $error("BEQ: MemWrite incorrect");

        assert (MemToReg == 1'b0)
            else $error("BEQ: MemToReg incorrect");

        assert (ALUSrc == 1'b0)
            else $error("BEQ: ALUSrc incorrect");

        assert (Branch == 1'b1)
            else $error("BEQ: Branch incorrect");

        $display("BEQ CONTROL PASS");


        // =====================================================
        // JAL
        // opcode = 1101111
        // =====================================================

        opcode = 7'b1101111;

        #1;

        assert (RegWrite == 1'b1)
            else $error("JAL: RegWrite incorrect");

        assert (MemRead == 1'b0)
            else $error("JAL: MemRead incorrect");

        assert (MemWrite == 1'b0)
            else $error("JAL: MemWrite incorrect");

        assert (MemToReg == 1'b0)
            else $error("JAL: MemToReg incorrect");

        assert (Branch == 1'b0)
            else $error("JAL: Branch incorrect");

        $display("JAL CONTROL PASS");


        // =====================================================
        // INVALID OPCODE
        // =====================================================

        opcode = 7'b1111111;

        #1;

        assert (RegWrite == 1'b0)
            else $error("INVALID: RegWrite should be 0");

        assert (MemRead == 1'b0)
            else $error("INVALID: MemRead should be 0");

        assert (MemWrite == 1'b0)
            else $error("INVALID: MemWrite should be 0");

        assert (MemToReg == 1'b0)
            else $error("INVALID: MemToReg should be 0");

        assert (ALUSrc == 1'b0)
            else $error("INVALID: ALUSrc should be 0");

        assert (Branch == 1'b0)
            else $error("INVALID: Branch should be 0");

        $display("INVALID OPCODE CONTROL PASS");


        // =====================================================
        // FINAL
        // =====================================================

        $display("------------------------------------------");
        $display("CONTROL UNIT ASSERTION TEST PASSED");
        $display("==========================================");

        $finish;

    end

endmodule