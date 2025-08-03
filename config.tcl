set ::env(DESIGN_NAME) fifo

set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

set ::env(CLOCK_PORT) clk
set ::env(CLOCK_PERIOD) "10"

# Increase core utilization margin
set ::env(FP_CORE_UTIL) 30
set ::env(PL_TARGET_DENSITY) 0.4

# Increase die/core area (default was too small for your FIFO)
set ::env(DIE_AREA) "0 0 200 200"

# Optional: disable placement resizer
#set ::env(PL_RESIZER_ENABLE) 0

# Optional: tighten congestion settings (OpenLane v1.1+)
set ::env(GRT_ALLOW_CONGESTION) 1
