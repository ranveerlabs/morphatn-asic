<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

calculates q0 * k0 + q1 * k1 + q2 * k2 + q3 * k3 by using one multiplier instead of 4 and when its idle it waits for start, if start is high while idle at rising clk edge it clears the accumulator and pair counter then sets busy high instead. on each of the next 4 rising edges it multiplies the current signed four-bit q and k then adds that product to the signed 10 bit accumulator and further advances the pair counter, on the fourth calc edge it also lowers busy and raises done which clears on the following edge while the result remains stored until reset or another accepted start. ex. 0 -> 6 -> 4-> -2 -> 2

## How to test

begin by setting start low and rst_n low, apply a rising clock edge to reset the circuit, then raise rst_n. next set uio[0] (start) high for one rising edge, then lower it. supply these packed input values (0x32, 0x2F, 0xE3, 0x14) on ui_in, one per calc clk. plz alter inputs on falling edges so theyre stable before the next rising edge, the first pair is consumed on the rising edge after start accepted, also after the fourth calculation edge, expect uio[4] (done) high and uio[3] (busy) low. read the ten-bit result as uo[7:0] contains bits 7 to 0 and uio[2:1] contains bits 9 to 8. for this example expect 2, also one clock later done should be low and the result should still be 2. sim test is run with make from test after installing its reqs

## External hardware

something like a controller or test board must supply clock/inputs and read outputs
