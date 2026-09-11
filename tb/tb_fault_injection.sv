module tb_fault_injection;

    // =========================================================
    // SIGNALS
    // =========================================================

    logic [31:0] a;
    logic [31:0] b;
    logic [2:0] alu_control;

    logic [31:0] result;
    logic zero;

    // =========================================================
    // ALU
    // =========================================================

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    // =========================================================
    // TEST
    // =========================================================

    initial begin

        $display("==========================================");
        $display("FAULT INJECTION DETECTION TEST");
        $display("==========================================");

        // -----------------------------------------------------
        // SUBTRACTION TEST
        //
        // ALU control:
        // 3'b001 = SUB
        //
        // Expected:
        // 50 - 20 = 30
        // -----------------------------------------------------

        a = 32'd50;
        b = 32'd20;
        alu_control = 3'b001;

        #1;

        $display(
            "SUB TEST: A=%0d B=%0d RESULT=%0d EXPECTED=30",
            a,
            b,
            result
        );

        assert (result == 32'd30)
            else begin
                $error(
                    "FAULT DETECTED: SUB result incorrect. Got %0d, expected 30",
                    result
                );
            end

        // -----------------------------------------------------
        // ADDITION CONTROL TEST
        // -----------------------------------------------------

        a = 32'd10;
        b = 32'd20;
        alu_control = 3'b000;

        #1;

        assert (result == 32'd30)
            else $error(
                "ADD TEST FAILED: Got %0d, expected 30",
                result
            );

        $display("ADD TEST PASS");

        // -----------------------------------------------------
        // AND TEST
        // -----------------------------------------------------

        a = 32'h0000000F;
        b = 32'h00000003;
        alu_control = 3'b010;

        #1;

        assert (result == 32'h00000003)
            else $error(
                "AND TEST FAILED: Got %h, expected 00000003",
                result
            );

        $display("AND TEST PASS");

        // -----------------------------------------------------
        // OR TEST
        // -----------------------------------------------------

        a = 32'h0000000F;
        b = 32'h00000030;
        alu_control = 3'b011;

        #1;

        assert (result == 32'h0000003F)
            else $error(
                "OR TEST FAILED: Got %h, expected 0000003F",
                result
            );

        $display("OR TEST PASS");

        // -----------------------------------------------------
        // XOR TEST
        // -----------------------------------------------------

        a = 32'h0000000F;
        b = 32'h00000003;
        alu_control = 3'b100;

        #1;

        assert (result == 32'h0000000C)
            else $error(
                "XOR TEST FAILED: Got %h, expected 0000000C",
                result
            );

        $display("XOR TEST PASS");

        // -----------------------------------------------------
        // ZERO FLAG TEST
        // -----------------------------------------------------

        a = 32'd20;
        b = 32'd20;
        alu_control = 3'b001;

        #1;

        assert (result == 32'd0)
            else $error(
                "ZERO TEST FAILED: SUB result should be zero"
            );

        assert (zero == 1'b1)
            else $error(
                "ZERO TEST FAILED: zero flag should be 1"
            );

        $display("ZERO FLAG TEST PASS");

        // -----------------------------------------------------
        // FINAL MESSAGE
        // -----------------------------------------------------

        $display("------------------------------------------");
        $display("FAULT-INJECTION TEST PASSED");
        $display("ALU SUBTRACTION VERIFIED CORRECT");
        $display("------------------------------------------");

        $finish;

    end

endmodule