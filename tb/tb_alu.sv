module tb_alu;

    logic [31:0] a;
    logic [31:0] b;
    logic [2:0]  alu_control;

    logic [31:0] result;
    logic        zero;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin

        // ADD
        a = 32'd10;
        b = 32'd20;
        alu_control = 3'b000;
        #10;

        if (result == 32'd30)
            $display("ADD PASS");
        else
            $display("ADD FAIL");

        // SUB
        a = 32'd20;
        b = 32'd10;
        alu_control = 3'b001;
        #10;

        if (result == 32'd10)
            $display("SUB PASS");
        else
            $display("SUB FAIL");

        // AND
        a = 32'b1010;
        b = 32'b1100;
        alu_control = 3'b010;
        #10;

        if (result == 32'b1000)
            $display("AND PASS");
        else
            $display("AND FAIL");

        // OR
        a = 32'b1010;
        b = 32'b1100;
        alu_control = 3'b011;
        #10;

        if (result == 32'b1110)
            $display("OR PASS");
        else
            $display("OR FAIL");

        // XOR
        a = 32'b1010;
        b = 32'b1100;
        alu_control = 3'b100;
        #10;

        if (result == 32'b0110)
            $display("XOR PASS");
        else
            $display("XOR FAIL");

        // ZERO FLAG
        a = 32'd10;
        b = 32'd10;
        alu_control = 3'b001;
        #10;

        if (zero == 1'b1)
            $display("ZERO FLAG PASS");
        else
            $display("ZERO FLAG FAIL");

        $display("");
        $display("================================");
        $display("ALL ALU TESTS COMPLETED");
        $display("================================");

        $finish;

    end

endmodule