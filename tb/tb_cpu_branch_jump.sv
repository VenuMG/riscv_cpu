module tb_cpu_branch_jump;

    logic clk;

    logic reset;

    logic [31:0] pc_out;

    logic [31:0] instruction_out;


    // =========================================================
    // DUT
    // =========================================================

    cpu dut (

        .clk(clk),

        .reset(reset),

        .pc_out(pc_out),

        .instruction_out(instruction_out)

    );


    // =========================================================
    // CLOCK
    // =========================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // =========================================================
    // TEST
    // =========================================================

    initial begin

        reset = 1'b1;

        // Reset CPU

        #12;

        reset = 1'b0;


        // =====================================================
        // MONITOR
        // =====================================================

        repeat (10) begin

            @(posedge clk);

            #1;

            $display(
                "PC = %0d | Instruction = %h | x1 = %0d | x2 = %0d | x3 = %0d | x4 = %0d | x5 = %0d",
                pc_out,
                instruction_out,
                dut.registers.registers[1],
                dut.registers.registers[2],
                dut.registers.registers[3],
                dut.registers.registers[4],
                dut.registers.registers[5]
            );

        end


        // =====================================================
        // RESULTS
        // =====================================================

        $display("");

        $display("================================");

        $display("DAY 7 RESULTS");

        $display("================================");


        $display("x1 = %0d", dut.registers.registers[1]);

        $display("x2 = %0d", dut.registers.registers[2]);

        $display("x3 = %0d", dut.registers.registers[3]);

        $display("x4 = %0d", dut.registers.registers[4]);

        $display("x5 = %0d", dut.registers.registers[5]);


        // =====================================================
        // CHECK x1
        // =====================================================

        if (dut.registers.registers[1] == 32'd10)

            $display("x1 PASS");

        else

            $display("x1 FAIL");


        // =====================================================
        // CHECK x2
        // =====================================================

        if (dut.registers.registers[2] == 32'd10)

            $display("x2 PASS");

        else

            $display("x2 FAIL");


        // =====================================================
        // CHECK BEQ
        // =====================================================

        // x3 must be 20.
        //
        // The instruction that writes 100
        // must have been skipped.

        if (dut.registers.registers[3] == 32'd20)

            $display("BEQ PASS");

        else

            $display("BEQ FAIL");


        // =====================================================
        // CHECK JAL LINK
        // =====================================================

        // JAL occurs at PC = 20.
        //
        // Therefore:
        //
        // x5 = PC + 4
        //    = 24

        if (dut.registers.registers[5] == 32'd24)

            $display("JAL LINK PASS");

        else

            $display("JAL LINK FAIL");


        // =====================================================
        // CHECK JAL TARGET
        // =====================================================

        // Instruction at PC = 24 writes x4 = 100.
        //
        // JAL should skip it.
        //
        // Therefore x4 must become 20.

        if (dut.registers.registers[4] == 32'd20)

            $display("JAL TARGET PASS");

        else

            $display("JAL TARGET FAIL");


        // =====================================================
        // COMPLETE
        // =====================================================

        $display("");

        $display("================================");

        $display("cpu BRANCH + JUMP TEST COMPLETED");

        $display("================================");


        $finish;

    end

endmodule