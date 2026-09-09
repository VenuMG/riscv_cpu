module tb_firmware;

    logic clk;
    logic reset;

    logic [31:0] pc_out;
    logic [31:0] instruction_out;

    cpu dut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruction_out(instruction_out)
    );

    // Clock: 10 ns period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Reset CPU
        reset = 1'b1;

        #12;

        reset = 1'b0;

        // Run firmware
        repeat (10) begin
            @(posedge clk);
            #1;

            $display(
                "PC = %0d | Instruction = %h | x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d x6=%0d x7=%0d",
                pc_out,
                instruction_out,
                dut.registers.registers[1],
                dut.registers.registers[2],
                dut.registers.registers[3],
                dut.registers.registers[4],
                dut.registers.registers[5],
                dut.registers.registers[6],
                dut.registers.registers[7]
            );
        end

        $display("");
        $display("==========================================");
        $display("DAY 10 FIRMWARE VERIFICATION");
        $display("==========================================");

        // x1 = 10
        if (dut.registers.registers[1] == 32'd10)
            $display("ADDI x1 PASS");
        else
            $display("ADDI x1 FAIL: x1 = %0d",
                     dut.registers.registers[1]);

        // x2 = 20
        if (dut.registers.registers[2] == 32'd20)
            $display("ADDI x2 PASS");
        else
            $display("ADDI x2 FAIL: x2 = %0d",
                     dut.registers.registers[2]);

        // x3 = 10 + 20 = 30
        if (dut.registers.registers[3] == 32'd30)
            $display("ADD PASS");
        else
            $display("ADD FAIL: x3 = %0d",
                     dut.registers.registers[3]);

        // x4 = 20 - 10 = 10
        if (dut.registers.registers[4] == 32'd10)
            $display("SUB PASS");
        else
            $display("SUB FAIL: x4 = %0d",
                     dut.registers.registers[4]);

        // x5 = 10 & 20 = 0
        if (dut.registers.registers[5] == 32'd0)
            $display("AND PASS");
        else
            $display("AND FAIL: x5 = %0d",
                     dut.registers.registers[5]);

        // x6 = 10 | 20 = 30
        if (dut.registers.registers[6] == 32'd30)
            $display("OR PASS");
        else
            $display("OR FAIL: x6 = %0d",
                     dut.registers.registers[6]);

        // x7 = 10 ^ 20 = 30
        if (dut.registers.registers[7] == 32'd30)
            $display("XOR PASS");
        else
            $display("XOR FAIL: x7 = %0d",
                     dut.registers.registers[7]);

        $display("");
        $display("==========================================");

        if ((dut.registers.registers[1] == 32'd10) &&
            (dut.registers.registers[2] == 32'd20) &&
            (dut.registers.registers[3] == 32'd30) &&
            (dut.registers.registers[4] == 32'd10) &&
            (dut.registers.registers[5] == 32'd0)  &&
            (dut.registers.registers[6] == 32'd30) &&
            (dut.registers.registers[7] == 32'd30)) begin

            $display("DAY 10 FIRMWARE VERIFICATION PASSED");

        end else begin

            $display("DAY 10 FIRMWARE VERIFICATION FAILED");

        end

        $display("==========================================");

        $finish;
    end

endmodule