module tb_cpu_complete;

    logic clk;
    logic reset;

    logic [31:0] pc_out;
    logic [31:0] instruction_out;


    // ============================================================
    // CPU INSTANCE
    // ============================================================

    cpu dut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruction_out(instruction_out)
    );


    // ============================================================
    // CLOCK
    // ============================================================

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    // ============================================================
    // TEST
    // ============================================================

    initial begin

        reset = 1'b1;

        #12;

        reset = 1'b0;


        // ========================================================
        // RUN CPU
        // ========================================================

        repeat (18) begin

            @(posedge clk);
            #1;

            $display(
                "PC = %0d | Instruction = %h | x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d x6=%0d x7=%0d x8=%0d x9=%0d x10=%0d x11=%0d",
                pc_out,
                instruction_out,
                dut.registers.registers[1],
                dut.registers.registers[2],
                dut.registers.registers[3],
                dut.registers.registers[4],
                dut.registers.registers[5],
                dut.registers.registers[6],
                dut.registers.registers[7],
                dut.registers.registers[8],
                dut.registers.registers[9],
                dut.registers.registers[10],
                dut.registers.registers[11]
            );

        end


        // ========================================================
        // RESULTS
        // ========================================================

        $display("");
        $display("==========================================");
        $display("DAY 9 COMPLETE CPU VERIFICATION RESULTS");
        $display("==========================================");


        // ========================================================
        // ADDI
        // ========================================================

        $display("");
        $display("---- IMMEDIATE INSTRUCTIONS ----");

        $display("x1 = %0d", dut.registers.registers[1]);

        if (dut.registers.registers[1] == 32'd10)
            $display("ADDI x1 PASS");
        else
            $display("ADDI x1 FAIL");


        $display("x2 = %0d", dut.registers.registers[2]);

        if (dut.registers.registers[2] == 32'd20)
            $display("ADDI x2 PASS");
        else
            $display("ADDI x2 FAIL");


        // ========================================================
        // ARITHMETIC
        // ========================================================

        $display("");
        $display("---- ARITHMETIC INSTRUCTIONS ----");

        $display("x3 = %0d", dut.registers.registers[3]);

        if (dut.registers.registers[3] == 32'd30)
            $display("ADD PASS");
        else
            $display("ADD FAIL");


        $display("x4 = %0d", dut.registers.registers[4]);

        if (dut.registers.registers[4] == 32'd10)
            $display("SUB PASS");
        else
            $display("SUB FAIL");


        // ========================================================
        // LOGICAL
        // ========================================================

        $display("");
        $display("---- LOGICAL INSTRUCTIONS ----");

        $display("x5 = %0d", dut.registers.registers[5]);

        if (dut.registers.registers[5] == 32'd0)
            $display("AND PASS");
        else
            $display("AND FAIL");


        $display("x6 = %0d", dut.registers.registers[6]);

        if (dut.registers.registers[6] == 32'd30)
            $display("OR PASS");
        else
            $display("OR FAIL");


        $display("x7 = %0d", dut.registers.registers[7]);

        if (dut.registers.registers[7] == 32'd30)
            $display("XOR PASS");
        else
            $display("XOR FAIL");


        // ========================================================
        // STORE
        // ========================================================

        $display("");
        $display("---- MEMORY INSTRUCTIONS ----");

        $display(
            "memory[0] = %0d",
            dut.data_mem.memory[0]
        );

        if (dut.data_mem.memory[0] == 32'd30)
            $display("SW PASS");
        else
            $display("SW FAIL");


        // ========================================================
        // LOAD
        // ========================================================

        $display(
            "x8 = %0d",
            dut.registers.registers[8]
        );

        if (dut.registers.registers[8] == 32'd30)
            $display("LW PASS");
        else
            $display("LW FAIL");


        // ========================================================
        // BEQ
        // ========================================================

        $display("");
        $display("---- BRANCH INSTRUCTION ----");

        $display(
            "x9 = %0d",
            dut.registers.registers[9]
        );

        if (dut.registers.registers[9] == 32'd55)
            $display("BEQ PASS");
        else
            $display("BEQ FAIL");


        // ========================================================
        // JAL
        // ========================================================

        $display("");
        $display("---- JUMP INSTRUCTION ----");

        $display(
            "x10 = %0d",
            dut.registers.registers[10]
        );

        if (dut.registers.registers[10] == 32'd52)
            $display("JAL LINK PASS");
        else
            $display("JAL LINK FAIL");


        $display(
            "x11 = %0d",
            dut.registers.registers[11]
        );

        if (dut.registers.registers[11] == 32'd77)
            $display("JAL TARGET PASS");
        else
            $display("JAL TARGET FAIL");


        // ========================================================
        // FINAL
        // ========================================================

        $display("");
        $display("==========================================");
        $display("DAY 9 COMPLETE CPU VERIFICATION PASSED");
        $display("==========================================");

        $finish;

    end

endmodule