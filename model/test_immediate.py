from riscv_reference import RiscVReferenceModel


def encode_itype(immediate, rs1, funct3, rd):
    immediate &= 0xFFF

    return (
        (immediate << 20)
        | (rs1 << 15)
        | (funct3 << 12)
        | (rd << 7)
        | 0b0010011
    )


def main():

    model = RiscVReferenceModel()

    program = [
        # ADDI x1, x0, 10
        encode_itype(10, 0, 0b000, 1),

        # ADDI x2, x0, 20
        encode_itype(20, 0, 0b000, 2),

        # ANDI x3, x2, 15
        # 20 & 15 = 4
        encode_itype(15, 2, 0b111, 3),

        # ORI x4, x0, 5
        # 0 | 5 = 5
        encode_itype(5, 0, 0b110, 4),

        # XORI x5, x4, 3
        # 5 ^ 3 = 6
        encode_itype(3, 4, 0b100, 5),
    ]

    model.run(program)

    expected = {
        1: 10,
        2: 20,
        3: 4,
        4: 5,
        5: 6,
    }

    print("==========================================")
    print("IMMEDIATE INSTRUCTION TEST")
    print("==========================================")

    passed = True

    for reg, expected_value in expected.items():

        actual = model.read_reg(reg)

        if actual == expected_value:
            print(
                f"x{reg}: EXPECTED={expected_value} "
                f"ACTUAL={actual} PASS"
            )
        else:
            print(
                f"x{reg}: EXPECTED={expected_value} "
                f"ACTUAL={actual} FAIL"
            )
            passed = False

    print("------------------------------------------")

    if passed:
        print("IMMEDIATE TEST PASSED")
        return 0

    print("IMMEDIATE TEST FAILED")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())