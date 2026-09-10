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


def encode_jal(rd, immediate):

    immediate &= 0x1FFFFF

    bit20 = (immediate >> 20) & 1
    bits10_1 = (immediate >> 1) & 0x3FF
    bit11 = (immediate >> 11) & 1
    bits19_12 = (immediate >> 12) & 0xFF

    return (
        (bit20 << 31)
        | (bits19_12 << 12)
        | (bit11 << 20)
        | (bits10_1 << 21)
        | (rd << 7)
        | 0b1101111
    )


def main():

    model = RiscVReferenceModel()

    program = [

        # PC = 0
        # x1 = 10
        encode_addi(10, 0, 1),

        # PC = 4
        # JAL x5, +8
        #
        # x5 = PC + 4 = 8
        # Target = PC + 8 = 12
        encode_jal(5, 8),

        # PC = 8
        # This instruction must be skipped
        encode_addi(99, 0, 2),

        # PC = 12
        # x2 = 77
        encode_addi(77, 0, 2),
    ]

    model.run(program)

    expected_x2 = 77
    expected_x5 = 8

    actual_x2 = model.read_reg(2)
    actual_x5 = model.read_reg(5)

    print("==========================================")
    print("JUMP INSTRUCTION TEST")
    print("==========================================")

    print(
        f"x2: EXPECTED={expected_x2} "
        f"ACTUAL={actual_x2} "
        f"{'PASS' if actual_x2 == expected_x2 else 'FAIL'}"
    )

    print(
        f"x5: EXPECTED={expected_x5} "
        f"ACTUAL={actual_x5} "
        f"{'PASS' if actual_x5 == expected_x5 else 'FAIL'}"
    )

    print("------------------------------------------")

    if actual_x2 == expected_x2 and actual_x5 == expected_x5:
        print("JAL TARGET TEST PASSED")
        print("JAL LINK TEST PASSED")
        return 0

    print("JUMP TEST FAILED")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())