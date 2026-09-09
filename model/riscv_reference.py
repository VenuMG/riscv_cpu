class RiscVReferenceModel:
    """
    Simple 32-bit RISC-V reference model.

    Supported instructions:
        ADD
        SUB
        AND
        OR
        XOR
        ADDI
        ANDI
        ORI
        XORI
        LW
        SW
        BEQ
        JAL
    """

    def __init__(self):
        self.pc = 0

        # 32 architectural registers
        self.registers = [0] * 32

        # Simple word-addressed data memory
        self.memory = [0] * 256

    # -----------------------------------------------------
    # Register operations
    # -----------------------------------------------------

    def read_reg(self, index):
        if index == 0:
            return 0

        return self.registers[index] & 0xFFFFFFFF

    def write_reg(self, index, value):
        if index != 0:
            self.registers[index] = value & 0xFFFFFFFF

    # -----------------------------------------------------
    # 32-bit signed conversion
    # -----------------------------------------------------

    @staticmethod
    def signed32(value):
        value &= 0xFFFFFFFF

        if value & 0x80000000:
            return value - 0x100000000

        return value

    # -----------------------------------------------------
    # Immediate sign extension
    # -----------------------------------------------------

    @staticmethod
    def sign_extend(value, bits):
        sign_bit = 1 << (bits - 1)

        if value & sign_bit:
            value -= 1 << bits

        return value & 0xFFFFFFFF

    # -----------------------------------------------------
    # Decode common fields
    # -----------------------------------------------------

    @staticmethod
    def decode(instruction):

        opcode = instruction & 0x7F
        rd = (instruction >> 7) & 0x1F
        funct3 = (instruction >> 12) & 0x07
        rs1 = (instruction >> 15) & 0x1F
        rs2 = (instruction >> 20) & 0x1F
        funct7 = (instruction >> 25) & 0x7F

        return opcode, rd, funct3, rs1, rs2, funct7

    # -----------------------------------------------------
    # Execute one instruction
    # -----------------------------------------------------

    def execute(self, instruction):

        instruction &= 0xFFFFFFFF

        opcode, rd, funct3, rs1, rs2, funct7 = \
            self.decode(instruction)

        next_pc = (self.pc + 4) & 0xFFFFFFFF

        value1 = self.read_reg(rs1)
        value2 = self.read_reg(rs2)

        # =================================================
        # R-type
        # =================================================

        if opcode == 0b0110011:

            if funct3 == 0b000:

                if funct7 == 0b0100000:
                    # SUB
                    result = value1 - value2
                else:
                    # ADD
                    result = value1 + value2

            elif funct3 == 0b111:
                # AND
                result = value1 & value2

            elif funct3 == 0b110:
                # OR
                result = value1 | value2

            elif funct3 == 0b100:
                # XOR
                result = value1 ^ value2

            else:
                result = 0

            self.write_reg(rd, result)

        # =================================================
        # I-type arithmetic
        # =================================================

        elif opcode == 0b0010011:

            immediate = instruction >> 20
            immediate = self.sign_extend(immediate, 12)

            if funct3 == 0b000:
                # ADDI
                result = value1 + immediate

            elif funct3 == 0b111:
                # ANDI
                result = value1 & immediate

            elif funct3 == 0b110:
                # ORI
                result = value1 | immediate

            elif funct3 == 0b100:
                # XORI
                result = value1 ^ immediate

            else:
                result = 0

            self.write_reg(rd, result)

        # =================================================
        # LW
        # =================================================

        elif opcode == 0b0000011:

            immediate = instruction >> 20
            immediate = self.sign_extend(immediate, 12)

            address = (value1 + immediate) & 0xFFFFFFFF

            index = (address >> 2) & 0xFF

            self.write_reg(
                rd,
                self.memory[index]
            )

        # =================================================
        # SW
        # =================================================

        elif opcode == 0b0100011:

            immediate = (
                ((instruction >> 25) << 5)
                | ((instruction >> 7) & 0x1F)
            )

            immediate = self.sign_extend(immediate, 12)

            address = (value1 + immediate) & 0xFFFFFFFF

            index = (address >> 2) & 0xFF

            self.memory[index] = value2 & 0xFFFFFFFF

        # =================================================
        # BEQ
        # =================================================

        elif opcode == 0b1100011:

            immediate = (
                (((instruction >> 31) & 0x1) << 12)
                | (((instruction >> 7) & 0x1) << 11)
                | (((instruction >> 25) & 0x3F) << 5)
                | (((instruction >> 8) & 0xF) << 1)
            )

            immediate = self.sign_extend(immediate, 13)

            if value1 == value2:
                next_pc = (
                    self.pc + immediate
                ) & 0xFFFFFFFF

        # =================================================
        # JAL
        # =================================================

        elif opcode == 0b1101111:

            immediate = (
                (((instruction >> 31) & 0x1) << 20)
                | (((instruction >> 12) & 0xFF) << 12)
                | (((instruction >> 20) & 0x1) << 11)
                | (((instruction >> 21) & 0x3FF) << 1)
            )

            immediate = self.sign_extend(immediate, 21)

            # Save return address
            self.write_reg(
                rd,
                self.pc + 4
            )

            # Jump
            next_pc = (
                self.pc + immediate
            ) & 0xFFFFFFFF

        # Update PC
        self.pc = next_pc

        # x0 must always remain zero
        self.registers[0] = 0

    # -----------------------------------------------------
    # Execute complete program
    # -----------------------------------------------------

    def run(self, program, cycles=None):

        if cycles is None:
            cycles = len(program)

        for _ in range(cycles):

            index = (self.pc >> 2)

            if index >= len(program):
                break

            instruction = program[index]

            self.execute(instruction)

    # -----------------------------------------------------
    # Display architectural state
    # -----------------------------------------------------

    def dump_state(self):

        print()
        print("==========================================")
        print("PYTHON REFERENCE MODEL")
        print("==========================================")

        print(f"PC = {self.pc}")

        for i in range(1, 12):

            print(
                f"x{i} = "
                f"{self.read_reg(i)}"
            )

        print()
        print("Memory[0] =", self.memory[0])
        print("==========================================")