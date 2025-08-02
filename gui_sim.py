# gui_sim.py

import tkinter as tk
from tkinter import ttk, messagebox
from datetime import datetime

class UART_FIFO_GUI:
    def __init__(self, root):
        self.root = root
        self.root.title("AXI → FIFO → UART Simulation")
        self.fifo = []
        self.max_fifo = 32
        self.log_lines = []
        self.dark_mode = True
        self.last_uart_frame = ""

        self.setup_styles()
        self.build_gui()

    def setup_styles(self):
        self.set_theme_colors()
        self.root.configure(bg=self.bg_color)
        style = ttk.Style()
        style.theme_use("clam")
        style.configure("TButton", background=self.accent, foreground=self.bg_color,
                        font=('Courier', 10, 'bold'))
        style.configure("TLabel", background=self.bg_color, foreground=self.fg_color)
        style.configure("TEntry", fieldbackground="#2e2e3e", foreground=self.fg_color)
        style.configure("TFrame", background=self.bg_color)

    def set_theme_colors(self):
        if self.dark_mode:
            self.bg_color = "#1e1e2f"
            self.fg_color = "#ffffff"
            self.accent = "#5ec3e6"
        else:
            self.bg_color = "#f4f4f4"
            self.fg_color = "#000000"
            self.accent = "#007acc"

    def toggle_theme(self):
        self.dark_mode = not self.dark_mode
        self.setup_styles()
        for widget in self.root.winfo_children():
            widget.destroy()
        self.build_gui()

    def build_gui(self):
        frame = ttk.Frame(self.root)
        frame.pack(padx=10, pady=10)

        ttk.Label(frame, text="AXI Data (hex):").grid(row=0, column=0, sticky="w")
        self.input_entry = ttk.Entry(frame)
        self.input_entry.grid(row=0, column=1)
        ttk.Button(frame, text="Write to FIFO", command=self.write_to_fifo).grid(row=0, column=2, padx=5)

        self.fifo_canvas = tk.Canvas(frame, height=50, width=700, bg="black", scrollregion=(0, 0, 1600, 50))
        self.fifo_scroll = ttk.Scrollbar(frame, orient="horizontal", command=self.fifo_canvas.xview)
        self.fifo_canvas.configure(xscrollcommand=self.fifo_scroll.set)
        self.fifo_canvas.grid(row=1, column=0, columnspan=3)
        self.fifo_scroll.grid(row=2, column=0, columnspan=3, sticky="we")

        ttk.Label(frame, text="UART TX Frame (bits):").grid(row=3, column=0, sticky="w")
        self.uart_output = tk.Text(frame, height=3, width=50, bg="#2e2e3e", fg="lime", font=('Courier', 10))
        self.uart_output.grid(row=3, column=1, columnspan=2)

        ttk.Label(frame, text="ASCII Decoded:").grid(row=4, column=0, sticky="w")
        self.ascii_output = ttk.Label(frame, text="", foreground=self.accent)
        self.ascii_output.grid(row=4, column=1, sticky="w")

        self.canvas = tk.Canvas(frame, width=700, height=100, bg='white')
        self.canvas.grid(row=5, column=0, columnspan=3, pady=10)

        ttk.Button(frame, text="Send 1 Byte", command=self.send_uart).grid(row=6, column=0)
        ttk.Button(frame, text="Send All FIFO", command=self.send_all_uart).grid(row=6, column=1)
        ttk.Button(frame, text="Show Waveform", command=self.show_waveform_window).grid(row=6, column=2)

        ttk.Label(frame, text="AXI Write Log:").grid(row=7, column=0, sticky="w")
        self.axi_log = tk.Text(frame, height=5, width=70, bg="#2e2e3e", fg="white", font=('Courier', 9))
        self.axi_log.grid(row=8, column=0, columnspan=3)

        ttk.Button(frame, text="Toggle Light/Dark Mode", command=self.toggle_theme).grid(row=9, column=2, sticky="e")

        self.update_fifo_display()

    def update_fifo_display(self):
        self.fifo_canvas.delete("all")
        x = 10
        for val in self.fifo:
            self.fifo_canvas.create_rectangle(x, 10, x+40, 40, fill="green")
            self.fifo_canvas.create_text(x+20, 25, text=val, fill="black", font=('Courier', 10, 'bold'))
            x += 50

    def write_to_fifo(self):
        data = self.input_entry.get()
        if len(data) == 0:
            return
        try:
            value = int(data, 16)
            if len(self.fifo) < self.max_fifo:
                hexval = f"{value:02X}"
                self.fifo.append(hexval)
                self.input_entry.delete(0, tk.END)
                self.update_fifo_display()
                log = f"[{datetime.now().strftime('%H:%M:%S')}] AXI WRITE -> FIFO <= 0x{hexval}"
                self.axi_log.insert(tk.END, log + "\n")
                self.axi_log.see(tk.END)
            else:
                messagebox.showwarning("FIFO Full", "FIFO is full! Cannot write more data.")
        except:
            messagebox.showerror("Invalid Input", "Please enter a valid hexadecimal number.")

    def send_uart(self):
        if not self.fifo:
            return
        data_hex = self.fifo.pop(0)
        value = int(data_hex, 16)
        data_bin = bin(value)[2:].zfill(8)
        uart_frame = '0' + data_bin[::-1] + '1'
        self.uart_output.insert(tk.END, f"{uart_frame}  (0x{data_hex})\n")
        self.ascii_output.config(text=f"ASCII: '{chr(value)}'")
        self.draw_waveform_blocks(uart_frame)
        self.last_uart_frame = uart_frame
        self.update_fifo_display()

    def send_all_uart(self):
        if not self.fifo:
            return
        self.root.after(300, self._send_next)

    def _send_next(self):
        if not self.fifo:
            return
        self.send_uart()
        self.root.after(300, self._send_next)

    def draw_waveform_blocks(self, bits):
        self.canvas.delete("all")
        x = 10
        bit_width = 40
        for bit in bits:
            bit_val = int(bit)
            color = 'black' if bit_val == 1 else 'white'
            outline = 'blue'
            self.canvas.create_rectangle(x, 30, x + bit_width, 70, fill=color, outline=outline, width=2)
            self.canvas.create_text(x + bit_width / 2, 50, text=bit, fill='red', font=('Courier', 10, 'bold'))
            x += bit_width

    def show_waveform_window(self):
        if not self.last_uart_frame:
            return

        popup = tk.Toplevel(self.root)
        popup.title("UART Waveform Viewer")
        popup.geometry("800x200")
        popup.configure(bg="white")

        waveform_canvas = tk.Canvas(popup, width=750, height=150, bg='white')
        waveform_canvas.pack(padx=10, pady=10)

        x = 10
        bit_width = 40
        level_y_high = 40
        level_y_low = 100
        prev_y = level_y_low

        for bit in self.last_uart_frame:
            bit_val = int(bit)
            y = level_y_high if bit_val == 1 else level_y_low
            waveform_canvas.create_line(x, prev_y, x, y, fill='blue', width=2)
            waveform_canvas.create_line(x, y, x + bit_width, y, fill='blue', width=2)
            prev_y = y
            x += bit_width

def show_welcome():
    splash = tk.Tk()
    splash.title("Welcome")
    splash.geometry("600x300+400+200")
    splash.configure(bg="black")

    tk.Label(splash, text="AXI → FIFO → UART Simulation GUI", fg="lime", bg="black",
             font=("Consolas", 16, "bold")).pack(pady=30)

    tk.Label(splash, text="Simulate FIFO writes, visualize UART transmission,\n"
                          "switch themes, and show waveform in popup window.",
             fg="white", bg="black", font=("Arial", 11)).pack(pady=10)

    tk.Button(splash, text="Launch Simulation", font=("Arial", 12, "bold"),
              bg="cyan", command=lambda: [splash.destroy(), start_main_gui()]).pack(pady=30)

    splash.mainloop()

def start_main_gui():
    root = tk.Tk()
    app = UART_FIFO_GUI(root)
    root.mainloop()

if __name__ == "__main__":
    show_welcome()
