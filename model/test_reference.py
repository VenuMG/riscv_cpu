from riscv_reference import RiscVReferenceModel


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
# Same program used by Day 10 firmware
# ---------------------------------------------------------

program = [

    encode_addi(1, 0, 10),

    encode_addi(2, 0, 20),

    encode_r_type(
        3, 1, 2,
        0b000,
        0b0000000
    ),

    encode_r_type(
        4, 2, 1,
        0b000,
        0b0100000
    ),

    encode_r_type(
        5, 1, 2,
        0b111,
        0b0000000
    ),

    encode_r_type(
        6, 1, 2,
        0b110,
        0b0000000
    ),

    encode_r_type(
        7, 1, 2,
        0b100,
        0b0000000
    ),
]


# ---------------------------------------------------------
# Run reference model
# ---------------------------------------------------------

model = RiscVReferenceModel()

model.run(program)

model.dump_state()


# ---------------------------------------------------------
# Self-checking verification
# ---------------------------------------------------------

expected = {
    1: 10,
    2: 20,
    3: 30,
    4: 10,
    5: 0,
    6: 30,
    7: 30,
}


print()
print("REFERENCE MODEL CHECK")
print("------------------------------------------")

all_pass = True

for register, expected_value in expected.items():

    actual_value = model.read_reg(register)

    if actual_value == expected_value:

        print(
            f"x{register}: "
            f"EXPECTED={expected_value} "
            f"ACTUAL={actual_value} "
            f"PASS"
        )

    else:

        print(
            f"x{register}: "
            f"EXPECTED={expected_value} "
            f"ACTUAL={actual_value} "
            f"FAIL"
        )

        all_pass = False


print("------------------------------------------")

if all_pass:

    print("REFERENCE MODEL VERIFICATION PASSED")

else:

    print("REFERENCE MODEL VERIFICATION FAILED")