# Golden-RV
#### Verilog/SystemVerilog RISC-V Design Project
This project is an implementation of the RISC-V unprivileged ISA using Verilog and SystemVerilog for verification. The core architecture is inspired by what is presented in Patterson and Hennessy's Computer Organization and Design. This implementation has a five-stage pipeline that is very similar to what is used throughout most of the textbook. The current description does not target any physical technology, though after the design is further refined, there are plans to make it work with an FPGA.

**File Structure:**
 - **mem:** Verilog Memory files to test RISC-V programs
 - **pkg:** SystemVerilog files with packages used for verification.
 - **sim:** Simulation files (testbenches) in SystemVerilog.
 - **src:** Source files for the Verilog modules that make up the design.

### Architecture Description
The Golden-RV core is a multi-cycle, pipelined, single-issue core with 5 distinct stages:
 - **Fetch:** The `PC` register is used to determine what instruction is fetched from memory. The instruction is then placed in the `inst_reg` register.
 - **Decode:** This stage contains the controller that sets control signals according to the instruction decoded. It also contains the immediate generator and hazard detector modules. The register file is read during this state.
 - **Execute:** The ALU is contained in this stage, along with the forwarding module to avoid preventable data hazards. This is also when branches are determined to be taken or not taken.
 - **Memory:** The memory stage handles access to the main memory (load and store operations). It also has a detached part of the forwarding module to handle lw-sw dependencies.   
 - **Writeback:** Every write to the register file happens on this stage.

### Verification Methodology
The testbenches use SystemVerilog tasks to automatically evaluate a set of test vectors. (WIP)
