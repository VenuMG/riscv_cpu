module tb_data_memory;

    logic clk;
    logic reset;

    logic [31:0] address;
    logic [31:0] write_data;

    logic mem_read;
    logic mem_write;

    logic [31:0] read_data;

    data_memory dut (
        .clk(clk),
        .reset(reset),
        .address(address),
        .write_data(write_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data)
    );

    // Clock
    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    initial begin

        // Initial values
        reset     = 1'b1;
        address   = 32'b0;
        write_data = 32'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;

        #12;

        reset = 1'b0;

        // ==========================================
        // TEST 1: STORE 123 AT ADDRESS 0
        // ==========================================

        address    = 32'd0;
        write_data = 32'd123;
        mem_write  = 1'b1;

        @(posedge clk);
        #1;

        mem_write = 1'b0;

        $display("STORE TEST:");
        $display("Address = %0d | Data = %0d",
                 address,
                 dut.memory[address[9:2]]);

        // ==========================================
        // TEST 2: LOAD FROM ADDRESS 0
        // ==========================================

        mem_read = 1'b1;

        #1;

        $display("");
        $display("LOAD TEST:");
        $display("Address = %0d | Read Data = %0d",
                 address,
                 read_data);

        if (read_data == 32'd123)
            $display("LOAD PASS");
        else
            $display("LOAD FAIL");

        mem_read = 1'b0;

        // ==========================================
        // TEST 3: STORE 456 AT ADDRESS 4
        // ==========================================

        address    = 32'd4;
        write_data = 32'd456;
        mem_write  = 1'b1;

        @(posedge clk);
        #1;

        mem_write = 1'b0;

        // Load it back
        mem_read = 1'b1;

        #1;

        $display("");
        $display("SECOND MEMORY TEST:");
        $display("Address = %0d | Read Data = %0d",
                 address,
                 read_data);

        if (read_data == 32'd456)
            $display("SECOND LOAD PASS");
        else
            $display("SECOND LOAD FAIL");

        mem_read = 1'b0;

        // ==========================================
        // FINAL RESULT
        // ==========================================

        $display("");
        $display("================================");
        $display("DATA MEMORY TEST COMPLETED");
        $display("================================");

        $finish;

    end

endmodule