from riscv_reference import RiscVReferenceModel


def encode_addi(immediate, rs1, rd):

    immediate &= 0xFFF

    return (
        (immediate << 20)
        | (rs1 << 15)
        | (0b000 << 12)
        | (rd << 7)
        | 0b0010011
    )


def encode_lw(immediate, rs1, rd):

    immediate &= 0xFFF

    return (
        (immediate << 20)
        | (rs1 << 15)
        | (0b010 << 12)
        | (rd << 7)
        | 0b0000011
    )


def encode_sw(immediate, rs1, rs2):

    immediate &= 0xFFF

    imm_low = immediate & 0x1F
    imm_high = (immediate >> 5) & 0x7F

    return (
        (imm_high << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (0b010 << 12)
        | (imm_low << 7)
        | 0b0100011
    )


def main():

    model = RiscVReferenceModel()

    program = [

        # x1 = 123
        encode_addi(123, 0, 1),

        # SW x1, 0(x0)
        encode_sw(0, 0, 1),

        # LW x2, 0(x0)
        encode_lw(0, 0, 2),
    ]

    model.run(program)

    expected_memory = 123
    expected_x2 = 123

    actual_memory = model.memory[0]
    actual_x2 = model.read_reg(2)

    print("==========================================")
    print("MEMORY INSTRUCTION TEST")
    print("==========================================")

    memory_pass = actual_memory == expected_memory
    load_pass = actual_x2 == expected_x2

    print(
        f"Memory[0]: EXPECTED={expected_memory} "
        f"ACTUAL={actual_memory} "
        f"{'PASS' if memory_pass else 'FAIL'}"
    )

    print(
        f"x2: EXPECTED={expected_x2} "
        f"ACTUAL={actual_x2} "
        f"{'PASS' if load_pass else 'FAIL'}"
    )

    print("------------------------------------------")

    if memory_pass and load_pass:
        print("MEMORY TEST PASSED")
        return 0

    print("MEMORY TEST FAILED")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())