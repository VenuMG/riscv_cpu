#  C Firmware / RISC-V Program Generator
#
# Generates:
#   1. Machine-code instructions
#   2. rtl/instruction_memory.sv
#
# Supported instructions:
#   ADDI
#   ADD
#   SUB
#   AND
#   OR
#   XOR


def encode_addi(rd, rs1, imm):
    opcode = 0b0010011
    funct3 = 0b000

    imm &= 0xFFF

    return (
        (imm << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (rd << 7)
        | opcode
    )


def encode_r_type(rd, rs1, rs2, funct3, funct7):
    opcode = 0b0110011

    return (
        (funct7 << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (rd << 7)
        | opcode
    )


# ---------------------------------------------------------
# Firmware program
# ---------------------------------------------------------

program = [
    ("ADDI x1, x0, 10", encode_addi(1, 0, 10)),
    ("ADDI x2, x0, 20", encode_addi(2, 0, 20)),

    ("ADD  x3, x1, x2",
     encode_r_type(3, 1, 2, 0b000, 0b0000000)),

    ("SUB  x4, x2, x1",
     encode_r_type(4, 2, 1, 0b000, 0b0100000)),

    ("AND  x5, x1, x2",
     encode_r_type(5, 1, 2, 0b111, 0b0000000)),

    ("OR   x6, x1, x2",
     encode_r_type(6, 1, 2, 0b110, 0b0000000)),

    ("XOR  x7, x1, x2",
     encode_r_type(7, 1, 2, 0b100, 0b0000000)),
]


# ---------------------------------------------------------
# Display generated machine code
# ---------------------------------------------------------

print("")
print("==========================================")
print("RISC-V FIRMWARE GENERATOR")
print("==========================================")
print("")

for index, (assembly, instruction) in enumerate(program):
    print(
        f"PC = {index * 4:02d} | "
        f"{instruction:08X} | "
        f"{assembly}"
    )


# ---------------------------------------------------------
# Generate instruction_memory.sv
# ---------------------------------------------------------
import os

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
output_file = os.path.join(PROJECT_ROOT, "rtl", "instruction_memory.sv")

with open(output_file, "w") as f:

    f.write("""module instruction_memory (
    input logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255];

    initial begin

""")

    for index, (assembly, instruction) in enumerate(program):
        f.write(
            f"        memory[{index}] = 32'h{instruction:08X}; "
            f"// {assembly}\n"
        )

    f.write("""
        // Fill remaining memory with NOPs
        for (integer i = 7; i < 256; i = i + 1)
            memory[i] = 32'h00000013;

    end

    always_comb begin
        instruction = memory[address[9:2]];
    end

endmodule
""")

print("")
print("Generated:")
print("../rtl/instruction_memory.sv")
print("")