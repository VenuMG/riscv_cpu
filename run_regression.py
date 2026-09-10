import subprocess
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent


def run_test(number, name, script):
    print()
    print(f"[{number}/7] {name}")
    print("-" * 50)

    command = [
        sys.executable,
        str(PROJECT_ROOT / "model" / script)
    ]

    result = subprocess.run(
        command,
        cwd=PROJECT_ROOT,
        capture_output=True,
        text=True
    )

    if result.stdout:
        print(result.stdout)

    if result.returncode != 0:
        if result.stderr:
            print(result.stderr)

        print(f"{name} : FAIL")
        return False

    print(f"{name} : PASS")
    return True


def run_random_differential(number):
    print()
    print(f"[{number}/7] Random Differential")
    print("-" * 50)

    compare_script = PROJECT_ROOT / "model" / "compare_random.py"
    rtl_output = PROJECT_ROOT / "random_rtl_output.txt"
    expected_output = PROJECT_ROOT / "random_expected.txt"

    if not expected_output.exists():
        print("random_expected.txt not found")
        print("Run: python model/random_differential.py")
        print("Random Differential : FAIL")
        return False

    if not rtl_output.exists():
        print("random_rtl_output.txt not found")
        print("Run the Verilator randomized simulation first.")
        print("Random Differential : FAIL")
        return False

    command = [
        sys.executable,
        str(compare_script)
    ]

    result = subprocess.run(
        command,
        cwd=PROJECT_ROOT,
        capture_output=True,
        text=True
    )

    if result.stdout:
        print(result.stdout)

    if result.returncode != 0:
        if result.stderr:
            print(result.stderr)

        print("Random Differential : FAIL")
        return False

    print("Random Differential : PASS")
    return True


def main():
    print("==========================================")
    print("RISC-V CPU AUTOMATED REGRESSION")
    print("==========================================")

    tests = [
        ("Arithmetic", "test_reference.py"),
        ("Immediate", "test_immediate.py"),
        ("Memory", "test_memory.py"),
        ("Branch", "test_branch.py"),
        ("Jump", "test_jump.py"),
        ("Differential", "compare_full_cpu.py"),
    ]

    passed = 0

    for number, (name, script) in enumerate(tests, start=1):
        if run_test(number, name, script):
            passed += 1

    if run_random_differential(7):
        passed += 1

    total = 7

    print()
    print("------------------------------------------")
    print(f"TOTAL: {passed}/{total} TESTS PASSED")

    if passed == total:
        print("REGRESSION STATUS: PASS")
    else:
        print("REGRESSION STATUS: FAIL")

    print("==========================================")

    return 0 if passed == total else 1


if __name__ == "__main__":
    sys.exit(main())