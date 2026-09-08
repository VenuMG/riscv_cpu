module cpu (
    input logic clk,
    input logic reset,

    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);

    // ============================================================
    // PROGRAM COUNTER
    // ============================================================

    logic [31:0] pc;
    logic [31:0] next_pc;
    logic [31:0] pc_plus_4;

    program_counter pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    assign pc_out = pc;

    assign pc_plus_4 = pc + 32'd4;


    // ============================================================
    // INSTRUCTION MEMORY
    // ============================================================

    logic [31:0] instruction;

    instruction_memory instruction_mem (
        .address(pc),
        .instruction(instruction)
    );

    assign instruction_out = instruction;


    // ============================================================
    // INSTRUCTION DECODER
    // ============================================================

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [6:0] funct7;

    logic [2:0] decoder_alu_control;
    logic [31:0] immediate;

    instruction_decoder decoder (
        .instruction(instruction),

        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),

        .alu_control(decoder_alu_control),
        .immediate(immediate)
    );


    // ============================================================
    // CONTROL UNIT
    // ============================================================

    logic RegWrite;
    logic MemRead;
    logic MemWrite;
    logic MemToReg;
    logic ALUSrc;
    logic Branch;

    control_unit control (
        .opcode(opcode),

        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch)
    );


    // ============================================================
    // ALU CONTROL
    // ============================================================

    logic [2:0] alu_operation;

    alu_control alu_ctrl (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .alu_control(alu_operation)
    );


    // ============================================================
    // REGISTER FILE
    // ============================================================

    logic [31:0] register_data1;
    logic [31:0] register_data2;

    logic [31:0] write_back_data;

    register_file registers (
        .clk(clk),
        .reset(reset),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .write_data(write_back_data),
        .reg_write(RegWrite),

        .read_data1(register_data1),
        .read_data2(register_data2)
    );


    // ============================================================
    // ALU SECOND OPERAND MUX
    // ============================================================

    logic [31:0] alu_operand2;

    always_comb begin

        if (ALUSrc)
            alu_operand2 = immediate;
        else
            alu_operand2 = register_data2;

    end


    // ============================================================
    // ALU
    // ============================================================

    logic [31:0] alu_result;
    logic alu_zero;

    alu arithmetic_logic_unit (
        .a(register_data1),
        .b(alu_operand2),

        .alu_control(alu_operation),

        .result(alu_result),
        .zero(alu_zero)
    );


    // ============================================================
    // DATA MEMORY
    // ============================================================

    logic [31:0] memory_read_data;

    data_memory data_mem (
        .clk(clk),
        .reset(reset),

        .address(alu_result),

        .write_data(register_data2),

        .mem_read(MemRead),
        .mem_write(MemWrite),

        .read_data(memory_read_data)
    );


    // ============================================================
    // WRITEBACK MUX
    // ============================================================

    always_comb begin

        // Default: ALU result
        write_back_data = alu_result;

        // LW
        if (MemToReg)
            write_back_data = memory_read_data;

        // JAL
        if (opcode == 7'b1101111)
            write_back_data = pc_plus_4;

    end


    // ============================================================
    // BRANCH / JUMP TARGETS
    // ============================================================

    logic [31:0] branch_target;
    logic [31:0] jal_target;

    assign branch_target = pc + immediate;

    assign jal_target = pc + immediate;


    // ============================================================
    // NEXT PC LOGIC
    // ============================================================

    always_comb begin

        // Default: sequential execution
        next_pc = pc_plus_4;

        // BEQ
        if (Branch && alu_zero)
            next_pc = branch_target;

        // JAL
        if (opcode == 7'b1101111)
            next_pc = jal_target;

    end

endmodule