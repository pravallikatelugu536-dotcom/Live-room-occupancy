#!/bin/bash

echo "======================================"
echo " Live Room Occupancy Simulation"
echo "======================================"

# Compile
iverilog -g2012 \
    -o sim.out \
    ../rtl/room_occupancy.sv \
    ../tb/room_occupancy_tb.sv

if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

echo "Compilation successful."
echo ""

# Run simulation
vvp sim.out

echo ""
echo "======================================"
echo " Simulation finished"
echo "======================================"

# Open waveform if GTKWave is installed
if command -v gtkwave &> /dev/null
then
    gtkwave occupancy.vcd
else
    echo "GTKWave is not installed."
    echo "Install it using: sudo apt install gtkwave"
fi
