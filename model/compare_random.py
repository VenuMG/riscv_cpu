from pathlib import Path
import sys


PROJECT_ROOT = (
    Path(__file__).resolve().parent.parent
)

EXPECTED_FILE = (
    PROJECT_ROOT / "random_expected.txt"
)

RTL_OUTPUT_FILE = (
    PROJECT_ROOT / "random_rtl_output.txt"
)


def read_expected():

    expected = {}

    with open(
        EXPECTED_FILE,
        "r"
    ) as f:

        for line in f:

            parts = line.split()

            if len(parts) != 2:
                continue

            name = parts[0]
            value = int(parts[1])

            if name == "PC":

                expected["PC"] = value

            elif name.startswith("x"):

                expected[
                    int(name[1:])
                ] = value

    return expected


def read_rtl():

    actual = {}

    with open(
        RTL_OUTPUT_FILE,
        "r"
    ) as f:

        for line in f:

            parts = line.split()

            if len(parts) != 2:
                continue

            name = parts[0]
            value = int(parts[1])

            if name == "FINAL_PC":

                actual["PC"] = value

            elif name.startswith("x"):

                actual[
                    int(name[1:])
                ] = value

    return actual


def compare(
    expected,
    actual
):

    print()
    print(
        "=========================================="
    )

    print(
        "RANDOM DIFFERENTIAL VERIFICATION"
    )

    print(
        "=========================================="
    )

    passed = True

    # --------------------------------------------------------
    # Compare registers
    # --------------------------------------------------------

    for reg in range(1, 32):

        expected_value = (
            expected.get(reg)
        )

        actual_value = (
            actual.get(reg)
        )

        if expected_value == actual_value:

            print(
                f"x{reg:<2} "
                f"PYTHON={expected_value:<12} "
                f"RTL={actual_value:<12} "
                f"PASS"
            )

        else:

            print(
                f"x{reg:<2} "
                f"PYTHON={expected_value:<12} "
                f"RTL={actual_value:<12} "
                f"FAIL"
            )

            passed = False

    # --------------------------------------------------------
    # Compare PC
    # --------------------------------------------------------

    expected_pc = expected.get("PC")
    actual_pc = actual.get("PC")

    print(
        "-" * 42
    )

    if expected_pc == actual_pc:

        print(
            f"PC   PYTHON={expected_pc:<12} "
            f"RTL={actual_pc:<12} "
            f"PASS"
        )

    else:

        print(
            f"PC   PYTHON={expected_pc:<12} "
            f"RTL={actual_pc:<12} "
            f"FAIL"
        )

        passed = False

    # --------------------------------------------------------
    # Final result
    # --------------------------------------------------------

    print(
        "-" * 42
    )

    if passed:

        print(
            "RANDOM DIFFERENTIAL "
            "VERIFICATION PASSED"
        )

    else:

        print(
            "RANDOM DIFFERENTIAL "
            "VERIFICATION FAILED"
        )

    print(
        "=========================================="
    )

    return passed


def main():

    if not EXPECTED_FILE.exists():

        print(
            "ERROR: random_expected.txt "
            "does not exist."
        )

        print(
            "Run:"
        )

        print(
            "python model/random_differential.py"
        )

        return 1

    if not RTL_OUTPUT_FILE.exists():

        print(
            "ERROR: random_rtl_output.txt "
            "does not exist."
        )

        print(
            "Run the Verilator simulation "
            "and save its output first."
        )

        return 1

    expected = read_expected()
    actual = read_rtl()

    passed = compare(
        expected,
        actual
    )

    return 0 if passed else 1


if __name__ == "__main__":

    sys.exit(
        main()
    )