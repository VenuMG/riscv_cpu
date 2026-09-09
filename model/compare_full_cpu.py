import subprocess
import re
import sys

from riscv_reference import RiscVReferenceModel


# =========================================================
# Instruction Encoders
# =========================================================

def encode_addi(rd, rs1, immediate):
    opcode = 0b0010011
    funct3 = 0b000

    immediate &= 0xFFF

    return (
        (immediate << 20)
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


def encode_sw(rs2, rs1, immediate):
    opcode = 0b0100011
    funct3 = 0b010

    immediate &= 0xFFF

    imm_low = immediate & 0x1F
    imm_high = (immediate >> 5) & 0x7F

    return (
        (imm_high << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (imm_low << 7)
        | opcode
    )


def encode_lw(rd, rs1, immediate):
    opcode = 0b0000011
    funct3 = 0b010

    immediate &= 0xFFF

    return (
        (immediate << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (rd << 7)
        | opcode
    )


def encode_beq(rs1, rs2, immediate):
    opcode = 0b1100011
    funct3 = 0b000

    immediate &= 0x1FFF

    imm12 = (immediate >> 12) & 0x1
    imm10_5 = (immediate >> 5) & 0x3F
    imm4_1 = (immediate >> 1) & 0xF
    imm11 = (immediate >> 11) & 0x1

    return (
        (imm12 << 31)
        | (imm10_5 << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (imm4_1 << 8)
        | (imm11 << 7)
        | opcode
    )


def encode_jal(rd, immediate):
    opcode = 0b1101111

    immediate &= 0x1FFFFF

    imm20 = (immediate >> 20) & 0x1
    imm10_1 = (immediate >> 1) & 0x3FF
    imm11 = (immediate >> 11) & 0x1
    imm19_12 = (immediate >> 12) & 0xFF

    return (
        (imm20 << 31)
        | (imm19_12 << 12)
        | (imm11 << 20)
        | (imm10_1 << 21)
        | (rd << 7)
        | opcode
    )


# =========================================================
# Same program used by RTL
# =========================================================

# =========================================================
# Same program used by RTL
# =========================================================

program = [

    # PC 0
    # ADDI x1, x0, 10
    encode_addi(1, 0, 10),

    # PC 4
    # ADDI x2, x0, 20
    encode_addi(2, 0, 20),

    # PC 8
    # ADD x3, x1, x2
    encode_r_type(
        3,
        1,
        2,
        0b000,
        0b0000000
    ),

    # PC 12
    # SW x3, 0(x0)
    encode_sw(3, 0, 0),

    # PC 16
    # LW x8, 0(x0)
    encode_lw(8, 0, 0),

    # PC 20
    # BEQ x3, x8, +8
    encode_beq(3, 8, 8),

    # PC 24
    # ADDI x9, x0, 99
    # Skipped by BEQ
    encode_addi(9, 0, 99),

    # PC 28
    # ADDI x9, x0, 55
    encode_addi(9, 0, 55),

    # PC 32
    # JAL x10, +8
    encode_jal(10, 8),

    # PC 36
    # ADDI x11, x0, 99
    # Skipped by JAL
    encode_addi(11, 0, 99),

    # PC 40
    # ADDI x11, x0, 77
    encode_addi(11, 0, 77),

    # -----------------------------------------------------
    # NOPs - same as RTL instruction memory
    # -----------------------------------------------------

    # PC 44
    0x00000013,

    # PC 48
    0x00000013,

    # PC 52
    0x00000013,

    # PC 56
    0x00000013,

    # PC 60
    0x00000013,

    # PC 64
    0x00000013,
]


# =========================================================
# Python Reference Model
# =========================================================

def run_python_model():

    model = RiscVReferenceModel()

    model.run(program, cycles=17)

    state = {
        "x1": model.read_reg(1),
        "x2": model.read_reg(2),
        "x3": model.read_reg(3),
        "x8": model.read_reg(8),
        "x9": model.read_reg(9),
        "x10": model.read_reg(10),
        "x11": model.read_reg(11),
        "MEM0": model.memory[0],
        "PC": model.pc,
    }

    return state


# =========================================================
# Run Verilator
# =========================================================

def run_rtl():

    result = subprocess.run(
        ["./obj_dir/Vtb_differential.exe"],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:

        print("RTL simulation FAILED")
        print(result.stderr)

        sys.exit(1)

    return result.stdout


# =========================================================
# Parse RTL final state
# =========================================================

def parse_rtl(output):

    state = {}

    registers = [
        "x1",
        "x2",
        "x3",
        "x8",
        "x9",
        "x10",
        "x11",
    ]

    for reg in registers:

        pattern = rf"{reg}=(\d+)"

        matches = re.findall(pattern, output)

        if not matches:

            print(f"ERROR: Could not find {reg} in RTL output.")
            sys.exit(1)

        state[reg] = int(matches[-1])

    mem_matches = re.findall(r"MEM0=(\d+)", output)

    if not mem_matches:

        print("ERROR: Could not find MEM0 in RTL output.")
        sys.exit(1)

    state["MEM0"] = int(mem_matches[-1])

    pc_matches = re.findall(r"PC=(\d+)", output)

    if not pc_matches:

        print("ERROR: Could not find PC in RTL output.")
        sys.exit(1)

    state["PC"] = int(pc_matches[-1])

    return state


# =========================================================
# Compare
# =========================================================

def compare_states(expected, actual):

    print()
    print("==========================================")
    print("FULL CPU DIFFERENTIAL VERIFICATION")
    print("==========================================")

    all_pass = True

    order = [
        "x1",
        "x2",
        "x3",
        "x8",
        "x9",
        "x10",
        "x11",
        "MEM0",
        "PC",
    ]

    for item in order:

        expected_value = expected[item]
        actual_value = actual[item]

        if expected_value == actual_value:

            status = "PASS"

        else:

            status = "FAIL"
            all_pass = False

        print(
            f"{item:4s} "
            f"PYTHON={expected_value:<3d} "
            f"RTL={actual_value:<3d} "
            f"{status}"
        )

    print("------------------------------------------")

    if all_pass:

        print("FULL DIFFERENTIAL VERIFICATION PASSED")

    else:

        print("FULL DIFFERENTIAL VERIFICATION FAILED")

    print("==========================================")

    return all_pass


# =========================================================
# Main
# =========================================================

def main():

    print("Running Python reference model...")

    expected = run_python_model()

    print("Running Verilator RTL simulation...")

    rtl_output = run_rtl()

    actual = parse_rtl(rtl_output)

    passed = compare_states(
        expected,
        actual
    )

    if not passed:

        sys.exit(1)


if __name__ == "__main__":

    main()