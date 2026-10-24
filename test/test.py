# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles,FallingEdge


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    await FallingEdge(dut.clk)
    dut.rst_n.value = 1
    dut.uio_in.value=1
    await FallingEdge(dut.clk)
    dut.uio_in.value=0
    dut.ui_in.value=0x32
    await FallingEdge(dut.clk)
    dut.ui_in.value=0x2F
    await FallingEdge(dut.clk)
    dut.ui_in.value=0xE3
    await FallingEdge(dut.clk)
    dut.ui_in.value=0x14
    await FallingEdge(dut.clk)
    assert int(dut.uo_out.value) == 2
    assert int(dut.uio_out.value) == 16
    assert int(dut.uio_oe.value) == 30
    await FallingEdge(dut.clk)
    assert int(dut.uo_out.value) == 2
    assert int(dut.uio_out.value) == 0
