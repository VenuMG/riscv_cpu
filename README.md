# 32-bit RISC-V Processor with Automated Verification

A 32-bit single-cycle-style RISC-V processor implemented in SystemVerilog with a Python-based reference model and an automated verification environment.

## Project Overview

This project implements a focused subset of a 32-bit RISC-V processor and demonstrates both **RTL design** and **verification methodology**.

The processor datapath includes:

- Program Counter
- Instruction Memory
- Instruction Decoder
- Control Unit
- ALU Control
- Register File
- ALU
- Data Memory
- Write-back Logic

The verification environment includes:

- Directed testing
- Randomized testing
- Python reference modeling
- Differential verification
- SystemVerilog assertions
- Functional coverage
- Fault injection
- Automated regression

## Supported Instructions

### R-Type
- ADD
- SUB
- AND
- OR
- XOR

### I-Type
- ADDI
- ANDI
- ORI
- XORI

### Memory
- SW

### Branch
- BEQ

### Jump
- JAL

> This project implements a focused RISC-V instruction subset and is not a complete RV32I implementation.

## Architecture

```text
                    ┌─────────────────┐
                    │ Program Counter │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Instruction     │
                    │ Memory          │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Instruction     │
                    │ Decoder         │
                    └────────┬────────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
              ▼                             ▼
       ┌─────────────┐               ┌─────────────┐
       │ Control Unit│               │ Register    │
       │             │               │ File        │
       └──────┬──────┘               └──────┬──────┘
              │                             │
              │                             ▼
              │                      ┌─────────────┐
              └─────────────────────►│     ALU     │
                                     └──────┬──────┘
                                            │
                                            ▼
                                     ┌─────────────┐
                                     │ Data Memory │
                                     └──────┬──────┘
                                            │
                                            ▼
                                     ┌─────────────┐
                                     │ Write Back  │
                                     └─────────────┘