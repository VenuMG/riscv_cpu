from riscv_reference import RiscVReferenceModel


# =========================================================
# RISC-V instruction encoders
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
# Program
# =========================================================
#
# 0:   ADDI x1, x0, 10
# 4:   ADDI x2, x0, 20
# 8:   ADD  x3, x1, x2
# 12:  SW   x3, 0(x0)
# 16:  LW   x8, 0(x0)
# 20:  BEQ  x3, x8, +8
# 24:  ADDI x9, x0, 99       <- skipped
# 28:  ADDI x9, x0, 55
# 32:  JAL  x10, +8
# 36:  ADDI x11, x0, 99      <- skipped
# 40:  ADDI x11, x0, 77
#
# =========================================================

program = [
    encode_addi(1, 0, 10),                         # 0
    encode_addi(2, 0, 20),                         # 4
    encode_r_type(3, 1, 2, 0b000, 0b0000000),     # 8
    encode_sw(3, 0, 0),                             # 12
    encode_lw(8, 0, 0),                             # 16
    encode_beq(3, 8, 8),                            # 20
    encode_addi(9, 0, 99),                          # 24
    encode_addi(9, 0, 55),                          # 28
    encode_jal(10, 8),                              # 32
    encode_addi(11, 0, 99),                         # 36
    encode_addi(11, 0, 77),                         # 40
]


# =========================================================
# Run reference model
# =========================================================

model = RiscVReferenceModel()
model.run(program, cycles=11)


# =========================================================
# Expected architectural state
# =========================================================

expected_registers = {
    1: 10,
    2: 20,
    3: 30,
    8: 30,
    9: 55,
    10: 36,
    11: 77,
}

expected_memory_0 = 30


# =========================================================
# Verification
# =========================================================

print()
print("==========================================")
print("BRANCH + MEMORY + JUMP REFERENCE MODEL")
print("==========================================")

all_pass = True

for register, expected in expected_registers.items():

    actual = model.read_reg(register)

    if actual == expected:
        status = "PASS"
    else:
        status = "FAIL"
        all_pass = False

    print(
        f"x{register}: "
        f"EXPECTED={expected} "
        f"ACTUAL={actual} "
        f"{status}"
    )


print("------------------------------------------")

actual_memory = model.memory[0]

if actual_memory == expected_memory_0:
    print(
        f"Memory[0]: "
        f"EXPECTED={expected_memory_0} "
        f"ACTUAL={actual_memory} PASS"
    )
else:
    print(
        f"Memory[0]: "
        f"EXPECTED={expected_memory_0} "
        f"ACTUAL={actual_memory} FAIL"
    )
    all_pass = False


print("------------------------------------------")

print(f"Final PC = {model.pc}")

if all_pass:
    print("BRANCH + MEMORY + JUMP VERIFICATION PASSED")
else:
    print("BRANCH + MEMORY + JUMP VERIFICATION FAILED")

print("==========================================")