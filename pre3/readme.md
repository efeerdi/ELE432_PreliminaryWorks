# Multicycle RISC-V Processor

## Why We Did It
This project was developed for the ELE432 Advanced Digital Design Lab. The goal was to upgrade a basic single-cycle RISC-V processor into a **multicycle architecture**. This approach is more realistic and hardware-efficient, allowing us to use a single unified memory for both instructions and data by spreading execution across multiple clock cycles.

## What We Did
* **Built a Multicycle Core:** Replaced the combination-logic controller with an FSM (Finite State Machine) to manage instruction stages (Fetch, Decode, Execute, Mem, Writeback).
* **Added Custom Logic:** Modified the ALU and Decoders to support a custom `xor` instruction alongside standard RISC-V instructions (`add`, `lw`, `sw`, `beq`, `jal`, etc.).
* **Verification:** Tested the entire system (Top, Controller, Datapath, Memory) using a SystemVerilog testbench. Successfully executed a machine code program and verified the cycle-by-cycle hardware behavior.