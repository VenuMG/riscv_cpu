module tb_random;

    logic clk;
    logic reset;

    logic [31:0] pc;
    logic [31:0] instruction;

    cpu dut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc),
        .instruction_out(instruction)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;

        // Reset
        #20;

        reset = 0;

        // Execute exactly 100 instructions
        repeat (100) begin
            @(posedge clk);
            #1;
        end

        $display("==========================================");
        $display("RANDOM RTL VERIFICATION");
        $display("==========================================");

        $display("FINAL_PC %0d", pc);

        $display("REGISTERS");

        $display("x1 %0d", dut.registers.registers[1]);
        $display("x2 %0d", dut.registers.registers[2]);
        $display("x3 %0d", dut.registers.registers[3]);
        $display("x4 %0d", dut.registers.registers[4]);
        $display("x5 %0d", dut.registers.registers[5]);
        $display("x6 %0d", dut.registers.registers[6]);
        $display("x7 %0d", dut.registers.registers[7]);
        $display("x8 %0d", dut.registers.registers[8]);
        $display("x9 %0d", dut.registers.registers[9]);
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
