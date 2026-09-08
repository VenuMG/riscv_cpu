module tb_control_unit;

    logic [6:0] opcode;

    logic RegWrite;
    logic MemRead;
    logic MemWrite;
    logic MemToReg;
    logic ALUSrc;
    logic Branch;


    // ==========================================
    // DUT
    // ==========================================

    control_unit dut (

        .opcode(opcode),

        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch)

    );


    initial begin

        // ======================================
        // R-TYPE TEST
        // ======================================

        opcode = 7'b0110011;
        #1;

        if (RegWrite == 1'b1 &&
            MemRead  == 1'b0 &&
            MemWrite == 1'b0 &&
            MemToReg == 1'b0 &&
            ALUSrc   == 1'b0 &&
            Branch   == 1'b0)

            $display("R-TYPE CONTROL PASS");

        else
            $display("R-TYPE CONTROL FAIL");


        // ======================================
        // I-TYPE TEST
        // ======================================

        opcode = 7'b0010011;
        #1;

        if (RegWrite == 1'b1 &&
            MemRead  == 1'b0 &&
            MemWrite == 1'b0 &&
            MemToReg == 1'b0 &&
            ALUSrc   == 1'b1 &&
            Branch   == 1'b0)

            $display("I-TYPE CONTROL PASS");

        else
            $display("I-TYPE CONTROL FAIL");


        // ======================================
        // LW TEST
        // ======================================

        opcode = 7'b0000011;
        #1;

        if (RegWrite == 1'b1 &&
            MemRead  == 1'b1 &&
            MemWrite == 1'b0 &&
            MemToReg == 1'b1 &&
            ALUSrc   == 1'b1 &&
            Branch   == 1'b0)

            $display("LW CONTROL PASS");

        else
            $display("LW CONTROL FAIL");


        // ======================================
        // SW TEST
        // ======================================

        opcode = 7'b0100011;
        #1;

        if (RegWrite == 1'b0 &&
            MemRead  == 1'b0 &&
            MemWrite == 1'b1 &&
            MemToReg == 1'b0 &&
            ALUSrc   == 1'b1 &&
            Branch   == 1'b0)

            $display("SW CONTROL PASS");

        else
            $display("SW CONTROL FAIL");


        // ======================================
        // BEQ TEST
        // ======================================

        opcode = 7'b1100011;
        #1;

        if (RegWrite == 1'b0 &&
            MemRead  == 1'b0 &&
            MemWrite == 1'b0 &&
            MemToReg == 1'b0 &&
            ALUSrc   == 1'b0 &&
            Branch   == 1'b1)

            $display("BEQ CONTROL PASS");

        else
            $display("BEQ CONTROL FAIL");


        // ======================================
        // INVALID OPCODE TEST
        // ======================================

        opcode = 7'b1111111;
        #1;

        if (RegWrite == 1'b0 &&
            MemRead  == 1'b0 &&
            MemWrite == 1'b0 &&
            MemToReg == 1'b0 &&
            ALUSrc   == 1'b0 &&
            Branch   == 1'b0)

            $display("DEFAULT CONTROL PASS");

        else
            $display("DEFAULT CONTROL FAIL");


        // ======================================
        // TEST COMPLETE
        // ======================================

        $display("");
        $display("================================");
        $display("CONTROL UNIT TESTS COMPLETED");
        $display("================================");

        $finish;

    end

endmodule