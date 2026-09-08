module tb_cpu_load_store;

    logic clk;
    logic reset;

    logic [31:0] pc_out;
    logic [31:0] instruction_out;


    // ============================================================
    // CPU
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


        // --------------------------------------------------------
        // Execute program
        // --------------------------------------------------------

        repeat (10) begin

            @(posedge clk);

            #1;

            $display(
                "PC = %0d | Instruction = %h | x1 = %0d | x2 = %0d | x3 = %0d | x4 = %0d",
                pc_out,
                instruction_out,

                dut.registers.registers[1],
                dut.registers.registers[2],
                dut.registers.registers[3],
                dut.registers.registers[4]
            );

        end


        // ========================================================
        // RESULTS
        // ========================================================

        $display("");

        $display("================================");
        $display("DAY 8 LOAD / STORE RESULTS");
        $display("================================");


        // --------------------------------------------------------
        // x1
        // --------------------------------------------------------

        $display(
            "x1 = %0d",
            dut.registers.registers[1]
        );

        if (dut.registers.registers[1] == 32'd100)
            $display("ADDI PASS");
        else
            $display("ADDI FAIL");


        // --------------------------------------------------------
        // Memory address 0
        // --------------------------------------------------------

        $display(
            "memory[0] = %0d",
            dut.data_mem.memory[0]
        );

        if (dut.data_mem.memory[0] == 32'd100)
            $display("SW ADDRESS 0 PASS");
        else
            $display("SW ADDRESS 0 FAIL");


        // --------------------------------------------------------
        // x2
        // --------------------------------------------------------

        $display(
            "x2 = %0d",
            dut.registers.registers[2]
        );

        if (dut.registers.registers[2] == 32'd100)
            $display("LW ADDRESS 0 PASS");
        else
            $display("LW ADDRESS 0 FAIL");


        // --------------------------------------------------------
        // x3
        // --------------------------------------------------------

        $display(
            "x3 = %0d",
            dut.registers.registers[3]
        );

        if (dut.registers.registers[3] == 32'd200)
            $display("ADD PASS");
        else
            $display("ADD FAIL");


        // --------------------------------------------------------
        // Memory address 4
        // --------------------------------------------------------

        $display(
            "memory[1] = %0d",
            dut.data_mem.memory[1]
        );

        if (dut.data_mem.memory[1] == 32'd200)
            $display("SW ADDRESS 4 PASS");
        else
            $display("SW ADDRESS 4 FAIL");


        // --------------------------------------------------------
        // x4
        // --------------------------------------------------------

        $display(
            "x4 = %0d",
            dut.registers.registers[4]
        );

        if (dut.registers.registers[4] == 32'd200)
            $display("LW ADDRESS 4 PASS");
        else
            $display("LW ADDRESS 4 FAIL");


        // ========================================================
        // FINAL
        // ========================================================

        $display("");

        $display("================================");
        $display("DAY 8 LOAD / STORE TEST COMPLETED");
        $display("================================");

        $finish;

    end

endmodule