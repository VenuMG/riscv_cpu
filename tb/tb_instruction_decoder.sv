module tb_instruction_decoder;

    logic [31:0] instruction;

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [6:0] funct7;

    logic [2:0] alu_control;
    logic [31:0] immediate;

    instruction_decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .alu_control(alu_control),
        .immediate(immediate)
    );

    initial begin

        // ADD x3, x1, x2
        instruction = 32'h002081B3;
        #1;

        if (alu_control == 3'b000)
            $display("ADD DECODE PASS");
        else
            $display("ADD DECODE FAIL");

        // SUB x3, x1, x2
        instruction = 32'h402081B3;
        #1;

        if (alu_control == 3'b001)
            $display("SUB DECODE PASS");
        else
            $display("SUB DECODE FAIL");

        // AND x3, x1, x2
        instruction = 32'h0020F1B3;
        #1;

        if (alu_control == 3'b010)
            $display("AND DECODE PASS");
        else
            $display("AND DECODE FAIL");

        // OR x3, x1, x2
        instruction = 32'h0020E1B3;
        #1;

        if (alu_control == 3'b011)
            $display("OR DECODE PASS");
        else
            $display("OR DECODE FAIL");

        // XOR x3, x1, x2
        instruction = 32'h0020C1B3;
        #1;

        if (alu_control == 3'b100)
            $display("XOR DECODE PASS");
        else
            $display("XOR DECODE FAIL");

        // ADDI x5, x1, 10
        instruction = 32'h00A08293;
        #1;

        if (alu_control == 3'b000 && immediate == 32'd10)
            $display("ADDI DECODE PASS");
        else
            $display("ADDI DECODE FAIL");

        // ANDI x5, x1, 15
        instruction = 32'h00F0F293;
        #1;

        if (alu_control == 3'b010 && immediate == 32'd15)
            $display("ANDI DECODE PASS");
        else
            $display("ANDI DECODE FAIL");

        // ORI x5, x1, 15
        instruction = 32'h00F0E293;
        #1;

        if (alu_control == 3'b011 && immediate == 32'd15)
            $display("ORI DECODE PASS");
        else
            $display("ORI DECODE FAIL");

        // XORI x5, x1, 15
        instruction = 32'h00F0C293;
        #1;

        if (alu_control == 3'b100 && immediate == 32'd15)
            $display("XORI DECODE PASS");
        else
            $display("XORI DECODE FAIL");

        // ADDI x5, x1, -1
        instruction = 32'hFFF08293;
        #1;

        if (immediate == 32'hFFFFFFFF)
            $display("SIGN EXTENSION PASS");
        else
            $display("SIGN EXTENSION FAIL");

        $display("");
        $display("================================");
        $display("INSTRUCTION DECODER TESTS COMPLETED");
        $display("================================");

        $finish;

    end

endmodule