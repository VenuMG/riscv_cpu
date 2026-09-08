module tb_cpu;

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

        // Hold reset for one clock cycle
        #12;

        reset = 1'b0;


        // -----------------------------------------------------
        // Execute instructions
        // -----------------------------------------------------

        repeat (10) begin

            @(posedge clk);

            #1;

            $display(
                "PC = %0d | Instruction = %h",
                pc_out,
                instruction_out
            );

        end


        // -----------------------------------------------------
        // CHECK RESULTS
        // -----------------------------------------------------

        $display("");
        $display("================================");
        $display("REGISTER RESULTS");
        $display("================================");

        $display("x1 = %0d", dut.registers.registers[1]);
        $display("x2 = %0d", dut.registers.registers[2]);
        $display("x3 = %0d", dut.registers.registers[3]);
        $display("x4 = %0d", dut.registers.registers[4]);
        $display("x5 = %0d", dut.registers.registers[5]);
        $display("x6 = %0d", dut.registers.registers[6]);
        $display("x7 = %0d", dut.registers.registers[7]);


        // -----------------------------------------------------
        // AUTOMATIC CHECKS
        // -----------------------------------------------------

        if (dut.registers.registers[1] == 32'd5)
            $display("x1 PASS");
        else
            $display("x1 FAIL");


        if (dut.registers.registers[2] == 32'd10)
            $display("x2 PASS");
        else
            $display("x2 FAIL");


        if (dut.registers.registers[3] == 32'd15)
            $display("x3 PASS");
        else
            $display("x3 FAIL");


        if (dut.registers.registers[4] == 32'd5)
            $display("x4 PASS");
        else
            $display("x4 FAIL");


        if (dut.registers.registers[5] == 32'd0)
            $display("x5 PASS");
        else
            $display("x5 FAIL");


        if (dut.registers.registers[6] == 32'd15)
            $display("x6 PASS");
        else
            $display("x6 FAIL");


        if (dut.registers.registers[7] == 32'd15)
            $display("x7 PASS");
        else
            $display("x7 FAIL");


        $display("");
        $display("================================");
        $display("CPU DATAPATH TEST COMPLETED");
        $display("================================");

        $finish;

    end

endmodule