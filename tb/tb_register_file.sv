module tb_register_file;

    logic clk;
    logic reset;

    logic [4:0] rs1;
    logic [4:0] rs2;

    logic [4:0] rd;
    logic [31:0] write_data;
    logic reg_write;

    logic [31:0] read_data1;
    logic [31:0] read_data2;

    register_file dut (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk = 0;
        reset = 1;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;
        reg_write = 0;

        // Reset
        #10;
        reset = 0;

        // ------------------------------------------------
        // Test 1: Write 100 to x5 and read it
        // ------------------------------------------------

        rd = 5;
        write_data = 32'd100;
        reg_write = 1;

        #10;

        reg_write = 0;
        rs1 = 5;

        #2;

        if (read_data1 == 32'd100)
            $display("REGISTER WRITE/READ PASS");
        else
            $display("REGISTER WRITE/READ FAIL: Expected 100, Got %d",
                     read_data1);

        // ------------------------------------------------
        // Test 2: Write 200 to x10 and perform dual read
        // ------------------------------------------------

        rd = 10;
        write_data = 32'd200;
        reg_write = 1;

        #10;

        reg_write = 0;

        rs1 = 5;
        rs2 = 10;

        #2;

        if ((read_data1 == 32'd100) &&
            (read_data2 == 32'd200))
            $display("DUAL READ PASS");
        else
            $display("DUAL READ FAIL: x5=%d x10=%d",
                     read_data1, read_data2);

        // ------------------------------------------------
        // Test 3: x0 must always remain zero
        // ------------------------------------------------

        rd = 0;
        write_data = 32'd999;
        reg_write = 1;

        #10;

        reg_write = 0;
        rs1 = 0;

        #2;

        if (read_data1 == 32'd0)
            $display("X0 CONSTANT ZERO PASS");
        else
            $display("X0 CONSTANT ZERO FAIL: Got %d",
                     read_data1);

        // ------------------------------------------------
        // Test 4: Read both x0 and x10
        // ------------------------------------------------

        rs1 = 0;
        rs2 = 10;

        #2;

        if ((read_data1 == 32'd0) &&
            (read_data2 == 32'd200))
            $display("X0 AND REGISTER READ PASS");
        else
            $display("X0 AND REGISTER READ FAIL");

        // ------------------------------------------------
        // Test completed
        // ------------------------------------------------

        $display("");
        $display("================================");
        $display("REGISTER FILE TESTS COMPLETED");
        $display("================================");

        $finish;

    end

endmodule