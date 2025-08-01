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
