import subprocess
import re
import sys

from riscv_reference import RiscVReferenceModel


# ---------------------------------------------------------
# 1. Run Python reference model
# ---------------------------------------------------------

def run_reference_model():
    program = [
        0x00A00093,  # ADDI x1, x0, 10
        0x01400113,  # ADDI x2, x0, 20
        0x002081B3,  # ADD  x3, x1, x2
        0x40110233,  # SUB  x4, x2, x1
        0x0020F2B3,  # AND  x5, x1, x2
        0x0020E333,  # OR   x6, x1, x2
        0x0020C3B3,  # XOR  x7, x1, x2
    ]

    model = RiscVReferenceModel()
    model.run(program)

    return {
        1: model.read_reg(1),
        2: model.read_reg(2),
        3: model.read_reg(3),
        4: model.read_reg(4),
        5: model.read_reg(5),
        6: model.read_reg(6),
        7: model.read_reg(7),
    }


# ---------------------------------------------------------
# 2. Run Verilator RTL simulation
# ---------------------------------------------------------

def run_rtl():
    result = subprocess.run(
        ["./obj_dir/Vtb_firmware"],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print("RTL simulation failed.")
        print(result.stderr)
        sys.exit(1)

    return result.stdout


# ---------------------------------------------------------
# 3. Extract final RTL register values
# ---------------------------------------------------------

def parse_rtl_output(output):

    lines = output.strip().splitlines()

    rtl_values = {}

    # Find the last normal CPU trace line.
    # Example:
    #
    # PC = 40 | Instruction = 00000013 |
    # x1=10 x2=20 x3=30 x4=10 x5=0 x6=30 x7=30

    pattern = re.compile(
        r"x1=(\d+)\s+"
        r"x2=(\d+)\s+"
        r"x3=(\d+)\s+"
        r"x4=(\d+)\s+"
        r"x5=(\d+)\s+"
        r"x6=(\d+)\s+"
        r"x7=(\d+)"
    )

    for line in lines:
        match = pattern.search(line)

        if match:
            values = match.groups()

            for i, value in enumerate(values, start=1):
                rtl_values[i] = int(value)

    if len(rtl_values) != 7:
        print("Could not extract all RTL registers.")
        sys.exit(1)

    return rtl_values


# ---------------------------------------------------------
# 4. Compare RTL and Python
# ---------------------------------------------------------

def compare_results(expected, actual):

    print()
    print("==========================================")
    print("RTL VS PYTHON DIFFERENTIAL VERIFICATION")
    print("==========================================")

    all_pass = True

    for register in range(1, 8):

        expected_value = expected[register]
        actual_value = actual[register]

        if expected_value == actual_value:
            status = "PASS"
        else:
            status = "FAIL"
            all_pass = False

        print(
            f"x{register}: "
            f"PYTHON={expected_value} "
            f"RTL={actual_value} "
            f"{status}"
        )

    print("------------------------------------------")

    if all_pass:
        print("DIFFERENTIAL VERIFICATION PASSED")
    else:
        print("DIFFERENTIAL VERIFICATION FAILED")

    print("==========================================")

    return all_pass


# ---------------------------------------------------------
# Main
# ---------------------------------------------------------

def main():

    print("Running Python reference model...")
    expected = run_reference_model()

    print("Running Verilator RTL simulation...")
    rtl_output = run_rtl()

    actual = parse_rtl_output(rtl_output)

    passed = compare_results(expected, actual)

    if not passed:
        sys.exit(1)


if __name__ == "__main__":
    main()