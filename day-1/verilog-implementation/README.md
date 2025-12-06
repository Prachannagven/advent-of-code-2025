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
