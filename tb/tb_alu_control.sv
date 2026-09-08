module tb_alu_control;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    logic [2:0] alu_control;


    // ==========================================
    // DUT
    // ==========================================

    alu_control dut (

        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .alu_control(alu_control)

    );


    initial begin

        // ======================================
        // R-TYPE ADD
        // ======================================

        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b000)
            $display("R-TYPE ADD CONTROL PASS");
        else
            $display("R-TYPE ADD CONTROL FAIL");


        // ======================================
        // R-TYPE SUB
        // ======================================

        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        #1;

        if (alu_control == 3'b001)
            $display("R-TYPE SUB CONTROL PASS");
        else
            $display("R-TYPE SUB CONTROL FAIL");


        // ======================================
        // R-TYPE AND
        // ======================================

        opcode = 7'b0110011;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b010)
            $display("R-TYPE AND CONTROL PASS");
        else
            $display("R-TYPE AND CONTROL FAIL");


        // ======================================
        // R-TYPE OR
        // ======================================

        opcode = 7'b0110011;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b011)
            $display("R-TYPE OR CONTROL PASS");
        else
            $display("R-TYPE OR CONTROL FAIL");


        // ======================================
        // R-TYPE XOR
        // ======================================

        opcode = 7'b0110011;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b100)
            $display("R-TYPE XOR CONTROL PASS");
        else
            $display("R-TYPE XOR CONTROL FAIL");


        // ======================================
        // I-TYPE ADDI
        // ======================================

        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b000)
            $display("ADDI CONTROL PASS");
        else
            $display("ADDI CONTROL FAIL");


        // ======================================
        // I-TYPE ANDI
        // ======================================

        opcode = 7'b0010011;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b010)
            $display("ANDI CONTROL PASS");
        else
            $display("ANDI CONTROL FAIL");


        // ======================================
        // I-TYPE ORI
        // ======================================

        opcode = 7'b0010011;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b011)
            $display("ORI CONTROL PASS");
        else
            $display("ORI CONTROL FAIL");


        // ======================================
        // I-TYPE XORI
        // ======================================

        opcode = 7'b0010011;
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b100)
            $display("XORI CONTROL PASS");
        else
            $display("XORI CONTROL FAIL");


        // ======================================
        // LOAD
        // ======================================

        opcode = 7'b0000011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b000)
            $display("LW ADDRESS CONTROL PASS");
        else
            $display("LW ADDRESS CONTROL FAIL");


        // ======================================
        // STORE
        // ======================================

        opcode = 7'b0100011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b000)
            $display("SW ADDRESS CONTROL PASS");
        else
            $display("SW ADDRESS CONTROL FAIL");


        // ======================================
        // BEQ
        // ======================================

        opcode = 7'b1100011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #1;

        if (alu_control == 3'b001)
            $display("BEQ SUBTRACT CONTROL PASS");
        else
            $display("BEQ SUBTRACT CONTROL FAIL");


        // ======================================
        // TEST COMPLETE
        // ======================================

        $display("");
        $display("================================");
        $display("ALU CONTROL TESTS COMPLETED");
        $display("================================");

        $finish;

    end

endmodule