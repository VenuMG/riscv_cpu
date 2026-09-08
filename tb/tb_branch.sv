module tb_branch;

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
        // MONITOR EXECUTION
        // =====================================================

        repeat (8) begin

            @(posedge clk);

            #1;

            $display(
                "PC = %0d | Instruction = %h | x1 = %0d | x2 = %0d | x3 = %0d",
                pc_out,
                instruction_out,
                dut.registers.registers[1],
                dut.registers.registers[2],
                dut.registers.registers[3]
            );

        end


        // =====================================================
        // RESULTS
        // =====================================================

        $display("");
        $display("================================");
        $display("BRANCH TEST RESULTS");
        $display("================================");

        $display("x1 = %0d", dut.registers.registers[1]);
        $display("x2 = %0d", dut.registers.registers[2]);
        $display("x3 = %0d", dut.registers.registers[3]);


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
        // CHECK BRANCH
        // =====================================================

        // If branch worked correctly,
        // instruction at PC=12 was skipped,
        // therefore x3 must be 20 instead of 100.

        if (dut.registers.registers[3] == 32'd20)
            $display("BEQ BRANCH TAKEN PASS");
        else
            $display("BEQ BRANCH TAKEN FAIL");


        $display("");
        $display("================================");
        $display("BEQ TEST COMPLETED");
        $display("================================");

        $finish;

    end

endmodule