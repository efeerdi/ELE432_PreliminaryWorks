# Lab Summary: Extending the Single-Cycle RISC-V Processor with XOR

## 1. Objective
The goal of this lab was to extend the base single-cycle RISC-V processor (based on Harris & Harris Digital Design and Computer Architecture) to support the `xor` instruction. The design was implemented in SystemVerilog and simulated using Quartus and ModelSim/Questa.

## 2. Hardware Modifications (SystemVerilog)
To support the new `xor` instruction, the following hardware components were modified or added:

* **ALU (`alu.sv`):** * Added a new case in the `always_comb` block to handle the XOR operation.
    * Assigned `ALUControl = 3'b100` for the operation: `3'b100: result = a ^ b;`
* **ALU Decoder (Control Unit):**
    * Updated the Truth Table to recognize the `funct3` value for XOR (`100`) under R-Type instructions (`ALUOp = 10`).
    * Mapped this condition to output the new `ALUControl` signal (`100`).
    * Added the missing `regfile` module to properly instantiate the 32x32-bit register file.

## 3. Software Modifications (Test Program)
To verify the hardware implementation, the provided assembly test program was modified:

* **Assembly Code (`riscvtest.s`):** * Inserted the instruction `xor x8, x2, x7` at address `0x10`. 
    * With `x2 = 5` and `x7 = 3`, the expected result is `x8 = 6` (5 XOR 3).
* **Machine Code (`riscvtest.txt`):**
    * Calculated the 32-bit machine code for the new instruction: `00714433`.
    * Inserted this hex code into the instruction memory file (`imem`) at the 5th position, shifting all subsequent instruction addresses down by 4 bytes.

## 4. Verification and Simulation Results
The testbench (`testbench.sv`) was updated to automatically verify the correctness of the processor.

* **XOR Verification:** * Added a checker to monitor when `PC == 32'h10`. 
    * At this state, the simulation successfully confirmed that `ALUResult` (mapped to `DataAdr`) equaled `32'h6`.
* **Final Program Verification:** * The simulation successfully reached the final state where the processor writes the value `25` (`0x19`) to memory address `100` (`0x64`).
    * The transcript printed: `Simulation succeeded`.
* **Waveform Analysis:** * Required signals (`clk, reset, PC, Instr, SrcA, SrcB, ALUResult, DataAdr, WriteData, MemWrite`) were successfully grouped and displayed in hexadecimal radix to validate the data path logic.