import random
from pathlib import Path

from riscv_reference import RiscVReferenceModel


# ============================================================
# CONFIGURATION
# ============================================================

PROJECT_ROOT = Path(__file__).resolve().parent.parent

SEED = 2026
PROGRAM_LENGTH = 100

RTL_MEMORY_FILE = (
    PROJECT_ROOT / "rtl" / "instruction_memory_random.sv"
)

RTL_TB_FILE = (
    PROJECT_ROOT / "tb" / "tb_random.sv"
)

EXPECTED_FILE = (
    PROJECT_ROOT / "random_expected.txt"
)


# ============================================================
# RISC-V ENCODERS
# ============================================================

def encode_itype(immediate, rs1, funct3, rd):
    """
    Encode I-type instructions.

    Supported:
        ADDI
        ANDI
        ORI
        XORI
    """

    immediate &= 0xFFF

    return (
        (immediate << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (rd << 7)
        | 0b0010011
    )


def encode_rtype(rs1, rs2, funct3, funct7, rd):
    """
    Encode R-type instructions.

    Supported:
        ADD
        SUB
        AND
        OR
        XOR
    """

    return (
        (funct7 << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (rd << 7)
        | 0b0110011
    )


# ============================================================
# RANDOM INSTRUCTION GENERATOR
# ============================================================

def generate_random_instruction():

    instruction_type = random.choice(
        [
            "ADD",
            "SUB",
            "AND",
            "OR",
            "XOR",
            "ADDI",
            "ANDI",
            "ORI",
            "XORI",
        ]
    )

    # x0 is avoided as destination.
    # Source registers can be x0.
    rd = random.randint(1, 31)
    rs1 = random.randint(0, 31)
    rs2 = random.randint(0, 31)

    # --------------------------------------------------------
    # R-TYPE
    # --------------------------------------------------------

    if instruction_type == "ADD":

        instruction = encode_rtype(
            rs1,
            rs2,
            0b000,
            0b0000000,
            rd
        )

        assembly = (
            f"ADD x{rd}, x{rs1}, x{rs2}"
        )

        return instruction, assembly

    if instruction_type == "SUB":

        instruction = encode_rtype(
            rs1,
            rs2,
            0b000,
            0b0100000,
            rd
        )

        assembly = (
            f"SUB x{rd}, x{rs1}, x{rs2}"
        )

        return instruction, assembly

    if instruction_type == "AND":

        instruction = encode_rtype(
            rs1,
            rs2,
            0b111,
            0b0000000,
            rd
        )

        assembly = (
            f"AND x{rd}, x{rs1}, x{rs2}"
        )

        return instruction, assembly

    if instruction_type == "OR":

        instruction = encode_rtype(
            rs1,
            rs2,
            0b110,
            0b0000000,
            rd
        )

        assembly = (
            f"OR x{rd}, x{rs1}, x{rs2}"
        )

        return instruction, assembly

    if instruction_type == "XOR":

        instruction = encode_rtype(
            rs1,
            rs2,
            0b100,
            0b0000000,
            rd
        )

        assembly = (
            f"XOR x{rd}, x{rs1}, x{rs2}"
        )

        return instruction, assembly

    # --------------------------------------------------------
    # I-TYPE
    # --------------------------------------------------------

    immediate = random.randint(-2048, 2047)

    if instruction_type == "ADDI":

        funct3 = 0b000

    elif instruction_type == "ANDI":

        funct3 = 0b111

    elif instruction_type == "ORI":

        funct3 = 0b110

    else:

        funct3 = 0b100

    instruction = encode_itype(
        immediate,
        rs1,
        funct3,
        rd
    )

    assembly = (
        f"{instruction_type} "
        f"x{rd}, x{rs1}, {immediate}"
    )

    return instruction, assembly


# ============================================================
# GENERATE RANDOM PROGRAM
# ============================================================

def generate_program():

    random.seed(SEED)

    program = []
    assembly = []

    for _ in range(PROGRAM_LENGTH):

        instruction, asm = (
            generate_random_instruction()
        )

        program.append(instruction)
        assembly.append(asm)

    return program, assembly


# ============================================================
# GENERATE RANDOM INSTRUCTION MEMORY
# ============================================================

def generate_instruction_memory(
    program,
    assembly
):

    with open(
        RTL_MEMORY_FILE,
        "w"
    ) as f:

        f.write(
            "module instruction_memory (\n"
        )

        f.write(
            "    input logic [31:0] address,\n"
        )

        f.write(
            "    output logic [31:0] instruction\n"
        )

        f.write(
            ");\n\n"
        )

        f.write(
            "    logic [31:0] memory [0:255];\n\n"
        )

        f.write(
            "    always_comb begin\n"
        )

        f.write(
            "        instruction = "
            "memory[address[9:2]];\n"
        )

        f.write(
            "    end\n\n"
        )

        f.write(
            "    initial begin\n"
        )

        # Random program
        for i, (
            machine_code,
            asm
        ) in enumerate(
            zip(program, assembly)
        ):

            f.write(
                f"        memory[{i}] = "
                f"32'h{machine_code:08X}; "
                f"// PC={i * 4} {asm}\n"
            )

        # Remaining locations = NOP
        for i in range(
            PROGRAM_LENGTH,
            256
        ):

            f.write(
                f"        memory[{i}] = "
                f"32'h00000013;\n"
            )

        f.write(
            "    end\n"
        )

        f.write(
            "endmodule\n"
        )


# ============================================================
# GENERATE RANDOM TESTBENCH
# ============================================================

def generate_testbench():

    with open(
        RTL_TB_FILE,
        "w"
    ) as f:

        f.write(
r'''module tb_random;

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
'''
        )


# ============================================================
# RUN PYTHON REFERENCE MODEL
# ============================================================

def run_reference_model(program):

    model = RiscVReferenceModel()

    model.run(
        program,
        cycles=PROGRAM_LENGTH
    )

    expected = {}

    for reg in range(1, 32):

        expected[reg] = model.read_reg(reg)

    expected["PC"] = model.pc

    return expected


# ============================================================
# SAVE EXPECTED RESULTS
# ============================================================

def save_expected_results(
    expected
):

    with open(
        EXPECTED_FILE,
        "w"
    ) as f:

        f.write(
            f"SEED {SEED}\n"
        )

        f.write(
            f"PROGRAM_LENGTH "
            f"{PROGRAM_LENGTH}\n"
        )

        f.write(
            f"PC {expected['PC']}\n"
        )

        for reg in range(1, 32):

            f.write(
                f"x{reg} "
                f"{expected[reg]}\n"
            )


# ============================================================
# PRINT PROGRAM
# ============================================================

def print_program(
    program,
    assembly
):

    print()
    print(
        "Generated randomized program:"
    )

    print(
        "-" * 50
    )

    for i, (
        instruction,
        asm
    ) in enumerate(
        zip(program, assembly)
    ):

        print(
            f"PC={i * 4:03d} | "
            f"0x{instruction:08X} | "
            f"{asm}"
        )

    print(
        "-" * 50
    )


# ============================================================
# MAIN
# ============================================================

def main():

    print(
        "=========================================="
    )

    print(
        "DAY 13 RANDOMIZED VERIFICATION"
    )

    print(
        "=========================================="
    )

    print(
        f"Random seed       : {SEED}"
    )

    print(
        f"Program length    : "
        f"{PROGRAM_LENGTH}"
    )

    print(
        "Instruction types : "
        "ADD/SUB/AND/OR/XOR + "
        "ADDI/ANDI/ORI/XORI"
    )

    # --------------------------------------------------------
    # Generate program
    # --------------------------------------------------------

    program, assembly = (
        generate_program()
    )

    print_program(
        program,
        assembly
    )

    # --------------------------------------------------------
    # Generate RTL files
    # --------------------------------------------------------

    print()
    print(
        "Generating randomized RTL "
        "instruction memory..."
    )

    generate_instruction_memory(
        program,
        assembly
    )

    print(
        f"Created: {RTL_MEMORY_FILE}"
    )

    print()
    print(
        "Generating randomized "
        "testbench..."
    )

    generate_testbench()

    print(
        f"Created: {RTL_TB_FILE}"
    )

    # --------------------------------------------------------
    # Python reference model
    # --------------------------------------------------------

    print()
    print(
        "Running Python reference model..."
    )

    expected = (
        run_reference_model(
            program
        )
    )

    # --------------------------------------------------------
    # Save expected state
    # --------------------------------------------------------

    save_expected_results(
        expected
    )

    print(
        f"Expected results saved to:"
    )

    print(
        f"{EXPECTED_FILE}"
    )

    # --------------------------------------------------------
    # Print expected state
    # --------------------------------------------------------

    print()
    print(
        "=========================================="
    )

    print(
        "PYTHON REFERENCE RESULTS"
    )

    print(
        "=========================================="
    )

    for reg in range(1, 32):

        print(
            f"x{reg:<2} = "
            f"{expected[reg]}"
        )

    print(
        f"PC   = {expected['PC']}"
    )

    print(
        "=========================================="
    )

    print()
    print(
        "DAY 13 STEP 1 COMPLETE"
    )

    print()
    print(
        "Next:"
    )

    print(
        "1. Compile tb_random using Verilator"
    )

    print(
        "2. Run Vtb_random"
    )

    print(
        "3. Run compare_random.py"
    )

    return 0


if __name__ == "__main__":

    raise SystemExit(
        main()
    )