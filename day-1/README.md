# Goals
The day 1 challenge was basically a challenge to track position. In C, python, or otherwise of course, this is quite easy. In an RTL however, this becomes a more interesting challenge.
Without a doubt, the biggest issue is the lack of a modulo operator, meaning that we can't just wrap around the data when we hit the 100 mark. Instead, a custom modulo module had to be made. In addition to this, to satisfy timing requirements, a FIFO was required at the hardware input side.
Another issue was the input stream. I've taken the stream to up to 32 bits wide, allowing large data to be entered. However, my hardware obviously doesn't support that. As such, I've added a hardware wrapper to go around my main core that satisifies my pin requirements.

# Design Elements
Most of the logic remains the same as that of the C program, but with a few changes to accomodate the parallel nature of hardware.

## Modulo Module
## FIFO Module
## Main Core
## Top Level Wrapper

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
