Live Room Occupancy Counter
1. Project Overview

The Live Room Occupancy Counter is a digital system designed to monitor the number of people currently present inside a room.

The system detects people entering and leaving the room using two input signals:

entry — indicates that a person has entered.

exit — indicates that a person has left.

The current number of people inside the room is stored in an occupancy counter.

The system also provides:

full — indicates that the room has reached its maximum capacity.

empty — indicates that the room is empty.

This project is implemented using SystemVerilog and can be simulated using Icarus Verilog and GTKWave, or using simulators such as ModelSim/Questa.

2. Features

Counts people entering the room.

Counts people leaving the room.

Displays the current occupancy.

Prevents the counter from becoming negative.

Prevents occupancy from exceeding the maximum capacity.

Provides full and empty status signals.

Synchronous operation using a clock.

Reset functionality.

Includes a self-checking testbench.

3. Block Diagram
                 +----------------------+
                 |                      |
      entry ---->|                      |
                 |                      |
      exit ----->|  Room Occupancy      |----> occupancy
                 |     Counter           |
       reset --->|                      |----> full
                 |                      |----> empty
       clk ----->|                      |
                 +----------------------+

4. Working Principle

The occupancy counter operates on the rising edge of the clock.

Person enters

When:

entry = 1
exit  = 0


the occupancy increases by one.

Person leaves

When:

entry = 0
exit  = 1


the occupancy decreases by one.

No movement

When:

entry = 0
exit  = 0


the occupancy remains unchanged.

Entry and exit simultaneously

When:

entry = 1
exit  = 1


one person enters and one person leaves at the same time, so the occupancy remains unchanged.

5. Capacity

The default room capacity is:

MAX_CAPACITY = 10


This value can be changed in the Verilog module.

For example:

parameter integer MAX_CAPACITY = 10;


If the occupancy reaches 10:

full = 1


Further entry requests are ignored until somebody leaves.

If the occupancy reaches 0:

empty = 1


Further exit requests are ignored.

6. Project Files
live-room-occupancy/
│
├── README.md
│
├── rtl/
│   └── room_occupancy.sv
│
├── tb/
│   └── room_occupancy_tb.sv
│
└── sim/
    └── run_sim.sh

7. Requirements

You can use any SystemVerilog-compatible simulator.

Recommended tools:

Icarus Verilog

GTKWave

Install on Ubuntu/Debian:

sudo apt update
sudo apt install iverilog gtkwave

8. Simulation

Move to the project directory:

cd live-room-occupancy


Compile the design and testbench:

iverilog -g2012 -o sim.out rtl/room_occupancy.sv tb/room_occupancy_tb.sv


Run the simulation:

vvp sim.out


Open the waveform:

gtkwave occupancy.vcd

9. Expected Simulation

The testbench checks the following conditions:

Test	Operation	Expected Occupancy
Reset	Reset system	0
Entry	One person enters	1
Entry	Another person enters	2
Entry	Another person enters	3
Exit	One person leaves	2
Exit	One person leaves	1
Exit	One person leaves	0
Exit at zero	Invalid exit	0
Multiple entries	People enter	Increasing count
Full capacity	Reach capacity	10
Entry when full	Extra entry	10
Simultaneous entry/exit	One in, one out	Unchanged
10. Example Waveform

The important signals to observe in GTKWave are:

clk
reset
entry
exit
occupancy
full
empty


Example:

Time       entry   exit   occupancy
-----------------------------------
0 ns        0       0        0
20 ns       1       0        1
40 ns       1       0        2
60 ns       1       0        3
80 ns       0       1        2
100 ns      0       1        1
120 ns      0       1        0

11. Applications

The concept can be used in:

Smart classrooms

Conference rooms

Laboratories

Libraries

Offices

Meeting rooms

Smart buildings

Industrial facilities

12. Future Improvements

The project can be extended by adding:

IR sensors for automatic entry/exit detection.

LCD or seven-segment display.

FPGA implementation.

Maximum-capacity alarm.

IoT connectivity.

Real-time monitoring dashboard.

Automatic door control.

Multiple-room occupancy monitoring.

13. Conclusion

The Live Room Occupancy Counter demonstrates how a digital counter can be used to monitor the number of people inside a room.

The SystemVerilog design provides a simple and reliable way to increase or decrease occupancy based on entry and exit signals while maintaining minimum and maximum limits.

14. Author

Project: Live Room Occupancy Counter
Language: SystemVerilog
Simulation: Icarus Verilog + GTKWave