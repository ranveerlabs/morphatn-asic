/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns/1ps

module tt_um_ranveerlabs_morphatn (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
wire signed [9:0] accumulator;
wire busy;
wire done;
morphatn core (
    .clk(clk),
    .reset(!rst_n),
    .start(uio_in[0]),
    .query(ui_in[3:0]),
    .key(ui_in[7:4]),
    .accumulator(accumulator),
    .busy(busy),
    .done(done)
);
  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = accumulator[7:0];  // Example: ou_out is the sum of ui_in and uio_in --not anymore lol
  assign uio_out[0] = 1'b0;
  assign uio_out[2:1] = accumulator[9:8];
  assign uio_out[3]=busy;
  assign uio_out[4]=done;
  assign uio_out[7:5]=3'b0;
  assign uio_oe = 8'b00011110;
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
