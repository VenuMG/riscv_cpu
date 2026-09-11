module tb_random;

    // =========================================================
    // CLOCK AND RESET
    // =========================================================

    logic clk;
    logic reset;

    // =========================================================
    // CPU OUTPUTS
    // =========================================================

    logic [31:0] pc_out;
    logic [31:0] instruction_out;

    // =========================================================
    // CPU INSTANCE
    // =========================================================

    cpu dut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruction_out(instruction_out)
    );

    // =========================================================
    // CLOCK GENERATION
    // =========================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // =========================================================
    // RESET GENERATION
    // =========================================================

    initial begin
        reset = 1'b1;

        #12;

        reset = 1'b0;
    end

    // =========================================================
    // PC PROGRESSION ASSERTION
    //
    // Random program contains only arithmetic/immediate
    // instructions, so PC must increase by exactly 4.
    // =========================================================

    logic [31:0] previous_pc;
    logic        pc_check_enable;

    always_ff @(posedge clk) begin

        if (reset) begin

            previous_pc     <= 32'b0;
            pc_check_enable <= 1'b0;

        end
        else begin

            if (pc_check_enable) begin

                assert (pc_out == previous_pc + 32'd4)
                    else $error(
                        "ASSERTION FAILED: PC did not advance by 4. Previous PC=%0d Current PC=%0d",
                        previous_pc,
                        pc_out
                    );

            end

            previous_pc     <= pc_out;
            pc_check_enable <= 1'b1;

        end

    end

    // =========================================================
    // MAIN TEST
    // =========================================================

    initial begin

        // Wait for reset to be released
        @(negedge reset);

        // Execute 100 instructions
        repeat (100) begin
            @(posedge clk);
        end

        // Allow nonblocking assignments to settle
        #1;

        // =====================================================
        // FINAL PC CHECK
        // =====================================================

        assert (pc_out == 32'd400)
            else $error(
                "ASSERTION FAILED: Final PC expected 400 but got %0d",
                pc_out
            );

        // =====================================================
        // DISPLAY RESULTS
        // =====================================================

        $display("==========================================");
        $display("RANDOM RTL VERIFICATION");
        $display("==========================================");

        $display("FINAL_PC %0d", pc_out);

        $display("REGISTERS");

        $display("x1 %0d",  dut.registers.registers[1]);
        $display("x2 %0d",  dut.registers.registers[2]);
        $display("x3 %0d",  dut.registers.registers[3]);
        $display("x4 %0d",  dut.registers.registers[4]);
        $display("x5 %0d",  dut.registers.registers[5]);
        $display("x6 %0d",  dut.registers.registers[6]);
        $display("x7 %0d",  dut.registers.registers[7]);
        $display("x8 %0d",  dut.registers.registers[8]);
        $display("x9 %0d",  dut.registers.registers[9]);
        $display("x10 %0d", dut.registers.registers[10]);
        $display("x11 %0d", dut.registers.registers[11]);
        $display("x12 %0d", dut.registers.registers[12]);
        $display("x13 %0d", dut.registers.registers[13]);
        $display("x14 %0d", dut.registers.registers[14]);
        $display("x15 %0d", dut.registers.registers[15]);
        $display("x16 %0d", dut.registers.registers[16]);
        $display("x17 %0d", dut.registers.registers[17]);
        $display("x18 %0d", dut.registers.registers[18]);
        $display("x19 %0d", dut.registers.registers[19]);
        $display("x20 %0d", dut.registers.registers[20]);
        $display("x21 %0d", dut.registers.registers[21]);
        $display("x22 %0d", dut.registers.registers[22]);
        $display("x23 %0d", dut.registers.registers[23]);
        $display("x24 %0d", dut.registers.registers[24]);
        $display("x25 %0d", dut.registers.registers[25]);
        $display("x26 %0d", dut.registers.registers[26]);
        $display("x27 %0d", dut.registers.registers[27]);
        $display("x28 %0d", dut.registers.registers[28]);
        $display("x29 %0d", dut.registers.registers[29]);
        $display("x30 %0d", dut.registers.registers[30]);
        $display("x31 %0d", dut.registers.registers[31]);

        $display("==========================================");

        $finish;

    end

endmodule