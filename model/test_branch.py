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


def encode_beq(rs1, rs2, immediate):

    immediate &= 0x1FFF

    bit12 = (immediate >> 12) & 1
    bit11 = (immediate >> 11) & 1
    bits10_5 = (immediate >> 5) & 0x3F
    bits4_1 = (immediate >> 1) & 0xF

    return (
        (bit12 << 31)
        | (bits10_5 << 25)
        | (rs2 << 20)
        | (rs1 << 15)
        | (0b000 << 12)
        | (bits4_1 << 8)
        | (bit11 << 7)
        | 0b1100011
    )


def main():

    model = RiscVReferenceModel()

    program = [

        # PC = 0
        # x1 = 10
        encode_addi(10, 0, 1),

        # PC = 4
        # x2 = 10
        encode_addi(10, 0, 2),

        # PC = 8
        # BEQ x1, x2, +8
        #
        # PC becomes 16
        encode_beq(1, 2, 8),

        # PC = 12
        # This instruction must be skipped
        encode_addi(99, 0, 3),

        # PC = 16
        # x3 = 55
        encode_addi(55, 0, 3),
    ]

    model.run(program)

    expected_x3 = 55
    actual_x3 = model.read_reg(3)

    print("==========================================")
    print("BRANCH INSTRUCTION TEST")
    print("==========================================")

    print(
        f"x3: EXPECTED={expected_x3} "
        f"ACTUAL={actual_x3} "
        f"{'PASS' if actual_x3 == expected_x3 else 'FAIL'}"
    )

    print("------------------------------------------")

    if actual_x3 == expected_x3:
        print("BEQ TAKEN TEST PASSED")
        return 0

    print("BEQ TAKEN TEST FAILED")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())