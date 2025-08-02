# AXI-Lite-Slave-with-FIFO-and-UART-Transmitter

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
│   ├── Makefile (optional)
├── waveforms/
│   └── *.vcd (from GTKWave)
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

clk	            Main system clock

reset	          Reset pulse at the beginning

write_en	       When FIFO is being written

data_in	        Data going into FIFO

tx	             Serial transmission (1 bit at a time)

tx_done	        UART finished sending a byte

AFTER Now Doing Full Integration!

WE WILL SEE:

  1  FIFO accepting values

  2  UART sending them one by one

  3  tx_done flag triggering FIFO read

  4  Serial waveform on tx line
