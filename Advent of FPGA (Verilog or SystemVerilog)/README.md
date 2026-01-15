# Advent of Code 2025 - FPGA Solutions (Verilog/SystemVerilog)

Hardware implementations for Advent of Code 2025 using **Verilog** and **SystemVerilog**. These solutions are designed to be synthesizable and runnable on actual FPGA hardware.

## Structure

```
day-1/                    # Verilog implementation
├── src/                  # Source files
│   ├── sol.v            # Main solution module
│   ├── mod100_pipelined.v
│   ├── hardware_wrapper.v
│   └── testbenches/     # Simulation testbenches
├── impl/                # FPGA implementation files (Gowin)
├── res/                 # Resources (waveform screenshots, etc.)
└── README.md

day-3/                    # SystemVerilog implementation
├── src/
│   ├── sol.sv           # Main solution
│   └── pipelined_sol.sv # Experimental pipelined version
├── sim/
│   └── tb_sol_streaming.sv
├── Makefile
└── README.md
```

## Completed Days

| Day | Language      | Status | Description |
|:---:|:-------------:|:------:|-------------|
| 1   | Verilog       | ✅     | Position tracking with pipelined mod-100 |
| 2   | -             | ❌     | Not implemented (CPU better suited) |
| 3   | SystemVerilog | ✅     | Monotonic stack for largest subsequence |

## Target Hardware

**SiSpeed Tang Nano 9k**
- FPGA: Gowin GW1NSR-4C4C6N144I
- LUTs: 8640
- Flip-Flops: 6480
- Max Frequency: 27MHz
- Pins: 48

## Building & Running

### Simulation (Icarus Verilog)
```bash
cd day-X/
make          # Compile and run simulation
make clean    # Remove generated files
make view     # Open waveforms in GTKWave
```

### FPGA Synthesis (Gowin)
Day 1 includes Gowin project files for synthesis on Tang Nano 9k.

## Design Highlights

### Day 1 - Pipelined Mod-100
The lack of a synthesizable modulo operator led to a custom pipelined mod-100 module using magic constant multiplication. 4-cycle latency with full throughput.

### Day 3 - Monotonic Stack
Implements a hardware monotonic stack with state machine for finding the lexicographically largest k-digit subsequence.

## Dependencies

- **Icarus Verilog** - For simulation (`iverilog`)
- **GTKWave** - For waveform viewing
- **Gowin IDE** - For FPGA synthesis (optional)

---

## Original Goals Section
The day 1 challenge was basically a challenge to track position. In C, python, or otherwise of course, this is quite easy. In an RTL however, this becomes a more interesting challenge.
Without a doubt, the biggest issue is the lack of a modulo operator, meaning that we can't just wrap around the data when we hit the 100 mark. Instead, a custom modulo module had to be made. In addition to this, to satisfy timing requirements, a FIFO was required at the hardware input side.
Another issue was the input stream. I've taken the stream to up to 32 bits wide, allowing large data to be entered. However, my hardware obviously doesn't support that. As such, I've added a hardware wrapper to go around my main core that satisifies my pin requirements.

# Design Elements
Most of the logic remains the same as that of the C program, but with a few changes to accomodate the parallel nature of hardware.

## Modulo Module
Magic modulo modulus operation that runs in 3 cycles (4 if you count input registering). This module is heavily pipelined to ensure timing requirements are met. It's also incredibly simple, and pretty hardware efficient for my use case.

## Main Core
Actually does the counting of zeroes and zero crossing using a pretty simple set of if statements. It's obviously written differently in each language (C, Verilog, Hardcaml), but the logic remains the same.

## Top Level Wrapper
This is only applicable to verilog and hardcaml, as the goal was to try to implement it on an FPGA. So I added a hardware wrapper to break up the input and output streams that could be sent over the limited number of pins on my FPGA board. More details in the verilog folder.

# Folders
The challenge was implemented in three languages:
- C
- Verilog
- Hardcaml

The C implementation can be found in folders "part-1" and "part-2". 
The Verilog implementation can be found in folder "verilog".
The Hardcaml implementation can be found in folder "hardcaml".

Verilog and Hardcaml have their own READMEs, so it may be worthwile to take a look at those for more information on the hardware implemenations.

# The Hardware Implementation
My goal was to run the hardware implementation on the [SiSpeed Tang Nano 9k](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html), a very small, cheap FPGA board that I had on me. I'm going to list a few of the important parameters of the board here:
- FPGA: Gowin GW1NSR-4C4C6N144I
- LUTs: 8640
- Flip-Flops: 6480
- Max Frequency:27MHz 
- Pins: 48

The pin config of the board is below:
![Tang Nano Pinout](https://wiki.sipeed.com/hardware/zh/tang/Tang-Nano-9K/assets/clip_image010.gif)

Now, one of the main problems is the pin count. Since I only had 48 pins, my input bit width was pretty restricted. As such, a hardware wrapper module was created.

*** The hardware wrapper module was common between my Hardcaml and Verilog Implementation***

The main reason for that was the fact that the hardware wrapper was a product of the hardware I was using, and didn't necessarily implement much logic other than breaking up the input and output data into smaller chunks so it was easily transmittable over the pins available. More importantly, I needed to know exactly how the data was moving with easy debugging at the topmost level of verilog, which hardcaml converted to verilog could not provide me.

The hardware wrapper was fairly simple, and an example of it's use can be seen in the below image (tested on part 1):

![Hardware Wrapper Testbench Functionality](./verilog/res/hardware_wrapper_waveforms.png)

The verilog code was then uploaded to the FPGA using [Gowin's IDE](http://www.gowinsemi.com/en/Download/index.html), using a private license. I then generated the bitstream with appropriate pin-ins and pin-outs based on my hardware configuration at that time. Data was sent over the bi-directional interface using a Raspberry Pi 3B+ as a controller.
