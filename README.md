
# SystemVerilog and C++ Synchronization Project

This repository contains a hardware-software synchronization project. It includes SystemVerilog files for hardware components and C++ implementations demonstrating file access synchronization using mutexes.

---

## 📁 Project Contents

### SystemVerilog Files:
- **actels.v** - Verilog module for hardware logic related to Actel FPGA components.
- **components.v** - Core hardware components like ALU, multiplexers, and registers.
- **controller.v** - Manages control signals for the hardware processor.
- **datapath.v** - Implements the processor's datapath, including memory and registers.
- **logics.v** - Implements supporting logic components.
- **toplevel.v** - The top-level module integrating all hardware components.

### C++ Files:
- **c1.cpp** - Demonstrates file access synchronization by incrementing a shared file value by 10.
- **c2.cpp** - Similar to c1.cpp, but increments the shared file value by 11.
- **s2-s1.cpp** - Reads and increments the shared file value by 13, ensuring thread-safe access.

---

## 💻 System Features

### Hardware Design:
- **Control Unit:** Manages control signals for the datapath components.
- **Datapath:** Consists of registers, ALU, memory, and multiplexers.
- **Logic Modules:** Implements various logical operations.
- **Top-Level Integration:** Combines all hardware components into a single processor.

### Software Synchronization:
- **Mutex-Based File Access:** Ensures thread-safe access to a shared file (`da.txt`).
- **Inter-Process Communication:** Demonstrates synchronization across multiple C++ processes.

---

## 🚀 How to Build and Run

### For Hardware Simulation:
1. **Clone the repository:**
   ```bash
   git clone https://github.com/YourUsername/YourRepo.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd YourRepo
   ```

3. **Compile and Simulate the Verilog Files:**
   Use a SystemVerilog simulator such as ModelSim, Quartus, or Icarus Verilog.
   ```bash
   iverilog -g2012 -o processor_sim toplevel.v testbench.sv
   vvp processor_sim
   ```

4. **View the Simulation Waveform (optional):**
   ```bash
   gtkwave processor_sim.vcd
   ```

### For C++ Programs:
1. **Build the C++ Files:**
   ```bash
   g++ c1.cpp -o c1.exe
   g++ c2.cpp -o c2.exe
   g++ s2-s1.cpp -o s2-s1.exe
   ```

2. **Run the Executables (separate terminals):**
   ```bash
   ./c1.exe
   ./c2.exe
   ./s2-s1.exe
   ```

---

## 📊 How It Works

1. **SystemVerilog Side:**
   - Initializes hardware modules and processes instructions.
   - Simulates processor operation using control and datapath modules.

2. **C++ Side:**
   - Accesses a shared file (`da.txt`) using Windows mutex synchronization.
   - Safely increments a shared value across multiple processes.

---

## ⚙️ Requirements

- **SystemVerilog Simulator:** ModelSim, Quartus, or Icarus Verilog.
- **C++ Compiler:** g++ (Windows/MinGW for Windows).
- **System:** Windows/Linux/Mac (compatible with simulation tools).

