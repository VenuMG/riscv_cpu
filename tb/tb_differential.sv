module tb_differential;

    logic clk;
    logic reset;

    logic [31:0] pc_out;
    logic [31:0] instruction_out;

    // ==========================================
    // DUT
    // ==========================================

    cpu dut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruction_out(instruction_out)
    );

    // ==========================================
    // Clock
    // ==========================================

    always #5 clk = ~clk;

    // ==========================================
    // Monitor
    // ==========================================

    always @(posedge clk) begin

        if (!reset) begin

            $display(
                "PC=%0d INST=%08h x1=%0d x2=%0d x3=%0d x8=%0d x9=%0d x10=%0d x11=%0d MEM0=%0d",
                pc_out,
                instruction_out,

                dut.registers.registers[1],
                dut.registers.registers[2],
                dut.registers.registers[3],
                dut.registers.registers[8],
                dut.registers.registers[9],
                dut.registers.registers[10],
                dut.registers.registers[11],

                dut.data_mem.memory[0]
            );

        end

    end

    // ==========================================
    // Test
    // ==========================================

    initial begin

        clk = 0;
        reset = 1;

        // Reset
        #20;

        reset = 0;

        // Run enough cycles for the entire program.
        repeat (15) begin
            @(posedge clk);
        end

        #2;

        // ==========================================
        // FINAL STATE
        // ==========================================

        $display("");
        $display("==========================================");
        $display("RTL FINAL STATE");
        $display("==========================================");

        $display("x1=%0d", dut.registers.registers[1]);
        $display("x2=%0d", dut.registers.registers[2]);
        $display("x3=%0d", dut.registers.registers[3]);
        $display("x8=%0d", dut.registers.registers[8]);
        $display("x9=%0d", dut.registers.registers[9]);
        $display("x10=%0d", dut.registers.registers[10]);
        $display("x11=%0d", dut.registers.registers[11]);

        $display("MEM0=%0d", dut.data_mem.memory[0]);

        $display("PC=%0d", pc_out);

        $display("==========================================");

        $finish;

    end

endmodule