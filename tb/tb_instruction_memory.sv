module tb_instruction_memory;

    logic [31:0] address;
    logic [31:0] instruction;

    instruction_memory dut (
        .address(address),
        .instruction(instruction)
    );

    initial begin

        // -----------------------------------------
        // Test 1: Address 0
        // -----------------------------------------

        address = 32'd0;

        #2;

        if (instruction == 32'h00500093)
            $display("INSTRUCTION 0 PASS");
        else
            $display("INSTRUCTION 0 FAIL: Got %h", instruction);

        // -----------------------------------------
        // Test 2: Address 4
        // -----------------------------------------

        address = 32'd4;

        #2;

        if (instruction == 32'h00A00113)
            $display("INSTRUCTION 4 PASS");
        else
            $display("INSTRUCTION 4 FAIL: Got %h", instruction);

        // -----------------------------------------
        // Test 3: Address 8
        // -----------------------------------------

        address = 32'd8;

        #2;

        if (instruction == 32'h002081B3)
            $display("INSTRUCTION 8 PASS");
        else
            $display("INSTRUCTION 8 FAIL: Got %h", instruction);

        // -----------------------------------------
        // Test 4: Address 12
        // -----------------------------------------

        address = 32'd12;

        #2;

        if (instruction == 32'h00310023)
            $display("INSTRUCTION 12 PASS");
        else
            $display("INSTRUCTION 12 FAIL: Got %h", instruction);

        // -----------------------------------------
        // Test completed
        // -----------------------------------------

        $display("");
        $display("================================");
        $display("INSTRUCTION MEMORY TESTS COMPLETED");
        $display("================================");

        $finish;

    end

endmodule