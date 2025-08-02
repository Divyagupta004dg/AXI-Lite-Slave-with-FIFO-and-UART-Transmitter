# AXI-Lite-Slave-with-FIFO-and-UART-Transmitter
    “Implemented a fully synthesizable AXI-write-to-UART FIFO bridge in Verilog with UVM-based functional verification on Ubuntu. Simulated using open-source tools and validated data integrity across protocol boundaries.”

Skills Proven:

    RTL Design (AXI, UART, FIFO)

    Clock Domain Handling

    UVM Verification

    Open-source toolchain

    Debugging with GTKWave
    
AXI_FIFO_UART_Project/

├── rtl/

│   ├── axi_lite_slave.v

│   ├── fifo.v

│   └── uart_tx.v

├── tb/

│   ├── axi_lite_slave_tb.v

│   ├── fifo_tb.v

│   └── uart_tx_tb.v

├── scripts/

│   ├── Makefile (optional

├── waveforms/

│   └── *.vcd (from GTKWave

├── doc/

│   └── README.md, block_diagram.png

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/768e4582-858f-47ca-b521-d1081d90e9c1" />


 STEP 1: Create Directory Structure

In your project folder:

mkdir -p rtl tb docs images scripts

Folders:

    rtl/ → Verilog/SystemVerilog RTL (AXI-Lite Slave, FIFO, UART)

    tb/ → Testbenches

    docs/ → Diagrams, reports (PDFs)

    images/ → PNGs/JPEGs for README or GitHub

    scripts/ → Simulation/Synthesis scripts (Makefile or Bash)
    
    PROJECT DIRECTORY
    
    mkdir -p ~/uart_axi_fifo_proj/{rtl,tb,doc,img,scripts} 
    
cd ~/uart_axi_fifo_proj


    STEP 2: Start Writing RTL (in rtl/)

Create 3 main files:

    axi_lite_slave.v

    fifo.v

    uart_tx.v

    1  FIFO Design Specs (Simplified)

We'll design a parameterized synchronous FIFO with the following features:

    Width and depth configurable

    Clocked on a single clk

    Supports:

        write_en, read_en

        full, empty, data_out

  <img width="602" height="402" alt="image" src="https://github.com/user-attachments/assets/3b0d5807-fbd0-44a8-903f-c230e331fcc3" />

  DIRECTORY STRUCTURE 
  
  uart_axi_fifo_proj/
  
├── rtl/

│   └── fifo.v

├── tb/

│   └── tb_fifo.v  ← (you just created this)

<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/2b5ce7e3-20b8-4e14-bcf6-74beb11f9bbc" />

FIFO Waveform

    1 Clock (clk)

        Make sure it's toggling consistently (square wave).

    2 Reset (reset)

        Initially high, then goes low → ensures FIFO starts empty.

   3  Write Enable (wr_en) & Write Data (data_in)

        When wr_en is high, check if data_in is stored in FIFO.

   4  Read Enable (rd_en) & Output (data_out)

        When rd_en is high, check if FIFO gives correct data_out (FIFO behavior).

    5 ointers (wr_ptr, rd_ptr)

        Observe how these increment and wrap around.

    6 Flags (full, empty)

        Ensure full goes high when FIFO is full.

        Ensure empty is high initially and clears when data is written.

   <img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/b8f1f34e-c522-4605-8ba5-23a421e319b8" />

   shows 
   
    UART transmitter:

    Accepts parallel input (tx_data)

    Sends serial data via tx line (start + 8 bits + stop)

    Raises tx_done when transmission completes

CURRENT FOLDER

uart_axi_fifo_proj/

├── rtl/

│   ├── fifo.v

│   ├── uart_tx.v  

├── tb/

│   ├── tb_uart_tx.v  

STEP 3: Now that UART TX and FIFO are individually working, you can connect them together so data written into FIFO is transmitted out serially.

Integrate FIFO → UART

New Module: uart_fifo_top.v

This module connects FIFO output to UART input.

<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/042b7d06-6b6b-4253-b73b-2908c6fa99fa" />

Signal	             Meaning

clk	 --------           Main system clock

reset	--------          Reset pulse at the beginning

write_en	--------      When FIFO is being written

data_in	---------        Data going into FIFO

tx	  --------           Serial transmission (1 bit at a time)

tx_done	--------      UART finished sending a byte

AFTER Now Doing Full Integration!

WE WILL SEE:

  1  FIFO accepting values

  2  UART sending them one by one

  3  tx_done flag triggering FIFO read

  4  Serial waveform on tx line

  Expected Behavior:

    Data written into FIFO (write_en goes high)

    UART transmits bytes one by one (tx waveform toggles serially)

    tx_done goes high at the end of each 10-bit sequence

    FIFO read enabled only when tx_done is high

We just Now Just Built:

A Mini Data Pipeline used in:

    Serial I/O controllers

    Sensor-to-UART bridges

    Embedded SoCs for telemetry/logging

    Low-power UART-based communication

FIFO buffers incoming data

UART sends them serially

Works without parallel bus timing issues

**STEP 4: AXI-Lite Slave block**

It’ll allow:

    Writing to FIFO from a CPU via AXI-Lite interface

    Real-world usage in ARM Cortex SoC + UART combo

 <img width="709" height="408" alt="image" src="https://github.com/user-attachments/assets/5b884355-7337-4cd0-9d78-6e9cd9e8f3d9" />

**We’ll implement write-only AXI-Lite, where a CPU or master can write bytes that get stored in a FIFO.**

ALSO 

making ~ axi_lite_slave.v  module — this is the key to interface with a processor or bus system (like an ARM CPU in SoCs)

AXI Signal	Role

s_axi_aw*	------ Write address (not used internally here)

s_axi_w*	------- Data — only wdata[7:0] sent to FIFO

s_axi_b*	------- Sends write response (OKAY)

fifo_wr_en	------Enables FIFO write

fifo_wr_data	----Sends byte to FIFO

**Project Structure Update**

uart_axi_fifo_proj/

├── rtl/

│   ├── axi_lite_slave.v  

│   ├── uart_tx.v

│   ├── fifo.v

│   └── uart_fifo_top.v

├── tb/

│   ├── tb_fifo.v

│   ├── tb_uart_tx.v

│   └── tb_uart_fifo_top.v

**STEP 5 Now Creating top module connecting axi_lite_slave → FIFO → UART**

making ~ axi_fifo_uart_top.v 

<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/7910075a-8d68-4d7f-b0ee-0318b3dea461" />

**axi_fifo_uart_top.v**	----RTL Design	Connects AXI interface, FIFO, and UART TX

Why do we need it?

This file connects all the major components together:

    AXI-Lite Slave (control interface)

    FIFO buffer (temporary storage)

    UART transmitter (serial output)

It is the heart of your system — the full datapath.

What does it do?

    Accepts data via AXI-Lite write transactions

    Stores the data in a FIFO buffer

    Then, automatically sends the data serially through the UART TX line

Internal modules used:

    axi_lite_slave.v → receives 32-bit data via AXI

    fifo.v → stores 8-bit chunks

    uart_tx.v → transmits data over TX serially

We can’t verify RTL code without a testbench.

**tb_axi_fifo_uart_top.v** ---- 	Simulates CPU-like AXI writes + dumps waveform

This testbench simulates the AXI writes and allows us to:

    Observe the FIFO being written

    Observe UART transmission starting automatically

    Validate correct data flow from AXI → FIFO → UART

⚙️ What does it do?

    Creates clock & reset

    Sends 3 AXI-style writes (s_axi_awvalid, s_axi_wdata)

    Waits for UART to transmit the data

    Dumps all signals into tb_axi_fifo_uart_top.vcd for GTKWave



Python GUI simulation that visually shows:

    ✅ AXI-style data writes

    ✅ FIFO buffer (filling & emptying)

    ✅ UART TX signal (bit stream visualizer)

    ✅ Optional: ASCII output of TX line

   1 mkdir -p ~/uart_axi_fifo_proj/{rtl,tb,doc,img,scripts} 
    
cd ~/uart_axi_fifo_proj

2. code gui_sim.py

3. python3 gui_sim.py
 
<img width="822" height="734" alt="image" src="https://github.com/user-attachments/assets/d8c4af2f-9f0c-4a53-aa07-a07bb537fc62" />

<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/e5b2a910-28c2-450f-bf26-13cfa3ba6a49" />
<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/1ae5f47c-ef2e-4e8a-8e3a-de2dde32d53f" />
<img width="750" height="535" alt="image" src="https://github.com/user-attachments/assets/d7a93d13-a02b-4e86-aa69-5e6943161d74" />
