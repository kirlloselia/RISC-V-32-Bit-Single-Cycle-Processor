# RISC-V 32-Bit Single-Cycle Processor

A hardware implementation of a 32-bit RISC-V single-cycle processor, following the architecture presented in **Digital Design and Computer Architecture: RISC-V Edition** by David Harris and Sarah Harris (DDCA).

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Supported Instructions](#supported-instructions)
3. [Architecture Overview](#architecture-overview)
4. [Datapath Components](#datapath-components)
5. [Control Unit](#control-unit)
6. [ALU](#alu)
7. [Datapath Diagram](#datapath-diagram)
8. [Simulation & Usage](#simulation--usage)
9. [References](#references)

---

## Project Overview

This project implements a **single-cycle** RV32I processor. In a single-cycle design, every instruction is fetched, decoded, executed, and written back within a **single clock cycle**. The critical path — the longest combinational path through the datapath — determines the minimum clock period.

The design closely follows Chapter 7 of *Digital Design and Computer Architecture: RISC-V Edition* (Harris & Harris), which derives the single-cycle microarchitecture from the RV32I base integer instruction set.

---

## Supported Instructions

The processor implements a representative subset of the **RV32I** base integer ISA.

### R-Type (Register–Register)

| Instruction | Operation                    | Description              |
|-------------|------------------------------|--------------------------|
| `add`       | rd = rs1 + rs2               | Add                      |
| `sub`       | rd = rs1 − rs2               | Subtract                 |
| `and`       | rd = rs1 & rs2               | Bitwise AND              |
| `or`        | rd = rs1 \| rs2              | Bitwise OR               |
| `xor`       | rd = rs1 ^ rs2               | Bitwise XOR              |
| `slt`       | rd = (rs1 < rs2) ? 1 : 0    | Set less than            |
| `sll`       | rd = rs1 << rs2[4:0]         | Shift left logical       |
| `srl`       | rd = rs1 >> rs2[4:0]         | Shift right logical      |
| `sra`       | rd = rs1 >>> rs2[4:0]        | Shift right arithmetic   |

### I-Type (Immediate)

| Instruction | Operation                      | Description              |
|-------------|--------------------------------|--------------------------|
| `lw`        | rd = Mem[rs1 + imm]            | Load word                |
| `addi`      | rd = rs1 + imm                 | Add immediate            |
| `andi`      | rd = rs1 & imm                 | AND immediate            |
| `ori`       | rd = rs1 \| imm                | OR immediate             |
| `slti`      | rd = (rs1 < imm) ? 1 : 0      | Set less than immediate  |
| `srli`      | rd = rs1 >> imm[4:0]           | Shift right logical imm  |
| `srai`      | rd = rs1 >>> imm[4:0]          | Shift right arith. imm   |

### S-Type (Store)

| Instruction | Operation                | Description |
|-------------|--------------------------|-------------|
| `sw`        | Mem[rs1 + imm] = rs2     | Store word  |

### B-Type (Branch)

| Instruction | Operation                               | Description     |
|-------------|-----------------------------------------|-----------------|
| `beq`       | if (rs1 == rs2) PC = PC + imm          | Branch if equal |

### J-Type (Jump)

| Instruction | Operation                    | Description        |
|-------------|------------------------------|--------------------|
| `jal`       | rd = PC+4; PC = PC + imm     | Jump and link      |

---

## Architecture Overview

A single-cycle processor completes **one instruction per clock cycle**. The datapath and control unit work together as follows:

```
Clock Cycle N:
  1. Fetch   – Read instruction from Instruction Memory at address PC
  2. Decode  – Identify opcode; read source registers; generate immediate
  3. Execute – ALU performs the required computation
  4. Memory  – Access Data Memory (load/store only)
  5. Write-Back – Write result back to the Register File; update PC
```

All five stages happen **within a single combinational path** — no pipeline registers exist between them. The state elements (PC, Instruction Memory, Register File, Data Memory) are updated on the **rising edge** of the clock.

---

## Datapath Components

### 1. Program Counter (PC)

- 32-bit register holding the address of the current instruction.
- Updated on every clock edge:
  - **Normal flow:** `PC ← PC + 4`
  - **Branch taken:** `PC ← PC + ImmExt` (B-type: `beq`)
  - **JAL:** `PC ← PC + ImmExt` (J-type)

```
PC Mux (PCNext):
  PCPlus4  = PC + 4
  PCTarget = PC + ImmExt   (branches / JAL)
  PCNext   = (PCSrc) ? PCTarget : PCPlus4
```

### 2. Instruction Memory

- Read-only synchronous/asynchronous memory.
- Output: 32-bit instruction word `Instr[31:0]` at address `PC`.

**Instruction encoding fields used by the datapath:**

| Field    | Bits      | Meaning                          |
|----------|-----------|----------------------------------|
| `op`     | [6:0]     | Opcode                           |
| `rd`     | [11:7]    | Destination register             |
| `funct3` | [14:12]   | Function (R/I/S/B types)         |
| `rs1`    | [19:15]   | Source register 1                |
| `rs2`    | [24:20]   | Source register 2                |
| `funct7` | [31:25]   | Function (R-type, bit 30 used)   |

The Extend unit reads instruction bits `[31:7]` and selects the correct immediate fields based on `ImmSrc`.

### 3. Register File

- 32 general-purpose 32-bit registers (`x0`–`x31`).
- `x0` is hardwired to zero and cannot be written.
- **Two asynchronous read ports** (`A1`/`A2` → `RD1`/`RD2`).
- **One synchronous write port** (`A3`/`WD3`, write enabled by `RegWrite` on clock edge).

```
RD1 = RegFile[rs1]
RD2 = RegFile[rs2]
if (RegWrite && rd != 0) RegFile[rd] ← Result   (on clk edge)
```

### 4. Sign-Extension Unit (Extend / Immgen)

Generates a 32-bit sign-extended immediate from bits of the instruction word. The format is selected by the `ImmSrc[1:0]` control signal:

| `ImmSrc` | Format  | Instruction Types | Immediate bits from `Instr`             |
|----------|---------|-------------------|-----------------------------------------|
| `00`     | I-type  | `lw`, `addi`, …   | `{Instr[31:20]}`                        |
| `01`     | S-type  | `sw`              | `{Instr[31:25], Instr[11:7]}`           |
| `10`     | B-type  | `beq`, `bne`      | `{Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0}` |
| `11`     | J-type  | `jal`             | `{Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0}` |

All formats are **sign-extended** to 32 bits using `Instr[31]`.

### 5. Arithmetic Logic Unit (ALU)

- Takes two 32-bit operands: `SrcA = RD1` and `SrcB = (ALUSrc) ? ImmExt : RD2`.
- Produces a 32-bit `ALUResult` and a 1-bit `Zero` flag.
- Operation selected by `ALUControl[2:0]` — see [ALU section](#alu).

### 6. Data Memory

- Word-addressable read/write memory.
- **Write:** `MemWrite = 1`, writes `RD2` to address `ALUResult` on clock edge.
- **Read:** asynchronous; `ReadData = Mem[ALUResult]`.

### 7. Result Multiplexer

Selects what is written back to the register file:

| `ResultSrc[1:0]` | Source        | Used by                   |
|------------------|---------------|---------------------------|
| `00`             | `ALUResult`   | R-type, I-type ALU        |
| `01`             | `ReadData`    | `lw`                      |
| `10`             | `PCPlus4`     | `jal`                     |

---

## Control Unit

The control unit is a **two-level combinational decoder** composed of:
1. **Main Decoder** – decodes `opcode` (7 bits) to produce most control signals.
2. **ALU Decoder** – combines `funct3`, `funct7[5]`, and `op[5]` to produce `ALUControl`.

### Main Decoder Truth Table

| `op[6:0]` | Instruction | `RegWrite` | `ImmSrc` | `ALUSrc` | `MemWrite` | `ResultSrc` | `Branch` | `ALUOp` | `Jump` |
|-----------|-------------|:---------:|:--------:|:--------:|:----------:|:-----------:|:--------:|:-------:|:------:|
| `0000011` | `lw`        | 1         | 00       | 1        | 0          | 01          | 0        | 00      | 0      |
| `0100011` | `sw`        | 0         | 01       | 1        | 1          | —          | 0        | 00      | 0      |
| `0110011` | R-type      | 1         | —       | 0        | 0          | 00          | 0        | 10      | 0      |
| `1100011` | `beq`       | 0         | 10       | 0        | 0          | —          | 1        | 01      | 0      |
| `0010011` | I-type ALU  | 1         | 00       | 1        | 0          | 00          | 0        | 10      | 0      |
| `1101111` | `jal`       | 1         | 11       | —        | 0          | 10          | 0        | —      | 1      |

> `—` = don't care. `ResultSrc` is don't care for `sw` and `beq` because `RegWrite = 0` (no register write occurs). `ALUSrc` and `ALUOp` are don't care for `jal` because the ALU is not used — `PCPlus4` is written directly to `rd` via `ResultSrc = 10`.

### Control Signals

| Signal        | Width  | Description                                                        |
|---------------|--------|--------------------------------------------------------------------|
| `RegWrite`    | 1-bit  | Enable write to register file                                      |
| `ImmSrc`      | 2-bit  | Selects immediate format for the sign-extension unit               |
| `ALUSrc`      | 1-bit  | `0` = second ALU operand from `RD2`; `1` = from `ImmExt`          |
| `MemWrite`    | 1-bit  | Enable write to data memory                                        |
| `ResultSrc`   | 2-bit  | Selects result written to register file (ALU / Mem / PC+4)        |
| `Branch`      | 1-bit  | Indicates a branch instruction (combined with `Zero` for `PCSrc`) |
| `ALUOp`       | 2-bit  | Passed to ALU decoder to determine `ALUControl`                   |
| `Jump`        | 1-bit  | Indicates an unconditional jump (`jal`)                            |

**PC source logic:**

```
PCSrc = Jump | (Branch & Zero)   // beq: branch taken when ALUResult == 0
```

### ALU Decoder Truth Table

| `ALUOp` | `funct3` | `{op[5], funct7[5]}` | `ALUControl` | Instruction          |
|---------|----------|----------------------|:------------:|----------------------|
| `00`    | x        | x                    | `000` (add)  | `lw`, `sw`           |
| `01`    | x        | x                    | `001` (subtract) | `beq`            |
| `10`    | `000`    | 00, 01, 10           | `000` (add)  | `addi`, `add`        |
| `10`    | `000`    | 11                   | `001` (subtract) | `sub`            |
| `10`    | `010`    | x                    | `101` (set less than) | `slt`       |
| `10`    | `110`    | x                    | `011` (or)   | `or`                 |
| `10`    | `111`    | x                    | `010` (and)  | `and`                |
| `10`    | `100`    | x                    | `100` (xor)  | `xor`                |
| `10`    | `001`    | x                    | `110` (shift left logical) | `sll`  |
| `10`    | `101`    | 00, 10               | `111` (shift right logical) | `srl`, `srli` |
| `10`    | `101`    | 01, 11               | TBD (shift right arithmetic) | `sra`, `srai` |

---

## ALU

The ALU accepts two 32-bit operands `A` and `B` and a 3-bit `ALUControl` signal.

| `ALUControl` | Operation                | `ALUResult`         |
|:------------:|--------------------------|---------------------|
| `000`        | ADD                      | A + B               |
| `001`        | SUB                      | A − B               |
| `010`        | AND                      | A & B               |
| `011`        | OR                       | A \| B              |
| `100`        | XOR                      | A ^ B               |
| `101`        | SLT (signed)             | (A < B) ? 1 : 0     |
| `110`        | SLL (shift left logical) | A << B[4:0]         |
| `111`        | SRL (shift right logical)| A >> B[4:0]         |
| TBD          | SRA (shift right arith.) | A >>> B[4:0]        |

**Status output:**

| Signal  | Description                               |
|---------|-------------------------------------------|
| `Zero`  | 1 if `ALUResult == 0` (used for branches) |

---

## Datapath Diagram

The following diagram shows the single-cycle datapath and control unit (from DDCA, Harris & Harris):

![RISC-V Single-Cycle Processor Architecture](https://github.com/user-attachments/assets/e11fde14-f8f3-4837-8545-79478d37306f)

> **Note:** The Control Unit receives `op[6:0]`, `funct3[14:12]`, `funct7[5]` (bit 30), and the `Zero` flag from the ALU. It drives `PCSrc`, `ResultSrc[1:0]`, `MemWrite`, `ALUControl[2:0]`, `ALUSrc`, `ImmSrc[1:0]`, and `RegWrite` across the datapath.

---

## Simulation & Usage

### Prerequisites

- A Verilog/SystemVerilog simulator such as:
  - [ModelSim / Questasim](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html)
  - [Icarus Verilog (iverilog)](http://iverilog.icarus.com/) + [GTKWave](https://gtkwave.sourceforge.net/)
  - [Vivado Simulator (xsim)](https://www.xilinx.com/products/design-tools/vivado.html)

### Running with Icarus Verilog

```bash
# Compile all source files and the testbench
iverilog -o riscv_sim \
  sources_1/new/RV32I.v \
  sources_1/new/DATAPATH.v \
  sources_1/new/ControlUnit/ControlUnit.v \
  sources_1/new/ControlUnit/Main_Decoder.v \
  sources_1/new/ControlUnit/ALU_Decoder.v \
  sources_1/new/ALUs/ALU.v \
  sources_1/new/ALUs/ADDER.v \
  sources_1/new/StateElements/REGFILE.v \
  sources_1/new/StateElements/IMEM.v \
  sources_1/new/StateElements/DMEM.v \
  sources_1/new/StateElements/PC.v \
  sources_1/new/EXTEND/EXTEND.V \
  sources_1/new/MUXes/mux2_1.v \
  sources_1/new/MUXes/mux3_1.v \
  sim_1/new/RISCV_tb.v

# Run simulation
vvp riscv_sim

# View waveforms
gtkwave dump.vcd
```

### File Structure

```
.
├── sim_1/
│   └── new/
│       └── RISCV_tb.v                  # Top-level testbench
├── sources_1/
│   └── new/
│       ├── RV32I.v                     # Top-level processor module
│       ├── DATAPATH.v                  # Datapath (PC, RF, ALU, memories, muxes)
│       ├── ALUs/
│       │   ├── ALU.v                   # Arithmetic Logic Unit
│       │   └── ADDER.v                 # Adder (PC+4 / PC+Imm)
│       ├── ControlUnit/
│       │   ├── ControlUnit.v           # Control unit (top-level)
│       │   ├── Main_Decoder.v          # Main decoder
│       │   └── ALU_Decoder.v           # ALU decoder
│       ├── EXTEND/
│       │   └── EXTEND.V                # Sign-extension / immediate generator
│       ├── MUXes/
│       │   ├── mux2_1.v                # 2-to-1 multiplexer
│       │   └── mux3_1.v                # 3-to-1 multiplexer
│       ├── StateElements/
│       │   ├── PC.v                    # Program Counter register
│       │   ├── REGFILE.v               # 32×32 Register File
│       │   ├── IMEM.v                  # Instruction Memory
│       │   ├── DMEM.v                  # Data Memory
│       │   ├── instructions.mem        # Assembled test program (hex)
│       │   └── riscvtest.txt           # RISC-V assembly test program
│       ├── new/
│       │   ├── RV32I.v                 # (alternate/updated top-level)
│       │   └── DATAPATH.v              # (alternate/updated datapath)
│       └── old/
│           ├── RISCV.v                 # (legacy top-level)
│           └── DATAPATH.v              # (legacy datapath)
└── README.md
```

---

## References

- **Harris, D. & Harris, S.** — *Digital Design and Computer Architecture: RISC-V Edition*, Morgan Kaufmann, 2022.  
  Chapters 6 (Architecture) and 7 (Microarchitecture) form the direct basis for this implementation.
- [RISC-V ISA Specification](https://riscv.org/technical/specifications/) — Official RISC-V Foundation specifications.
- [The RISC-V Reader](http://riscvbook.com/) — Patterson & Waterman, open-access introduction to RISC-V.
