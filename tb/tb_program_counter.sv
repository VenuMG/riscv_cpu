module tb_program_counter;

    logic clk;
    logic reset;
    logic [31:0] next_pc;

    logic [31:0] pc;

    program_counter dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        next_pc = 32'd0;

        // Test 1: Reset
        #10;

        if (pc == 32'd0)
            $display("PC RESET PASS");
        else
            $display("PC RESET FAIL: Expected 0, Got %d", pc);

        // Release reset
        reset = 0;

        // Test 2: PC = 4
        next_pc = 32'd4;
        #10;

        if (pc == 32'd4)
            $display("PC UPDATE 4 PASS");
        else
            $display("PC UPDATE 4 FAIL: Expected 4, Got %d", pc);

        // Test 3: PC = 8
        next_pc = 32'd8;
        #10;

        if (pc == 32'd8)
            $display("PC UPDATE 8 PASS");
        else
            $display("PC UPDATE 8 FAIL: Expected 8, Got %d", pc);

        // Test 4: PC = 12
        next_pc = 32'd12;
        #10;

        if (pc == 32'd12)
            $display("PC UPDATE 12 PASS");
        else
            $display("PC UPDATE 12 FAIL: Expected 12, Got %d", pc);

        $display("");
        $display("================================");
        $display("PROGRAM COUNTER TESTS COMPLETED");
        $display("================================");

        $finish;

    end

endmodule