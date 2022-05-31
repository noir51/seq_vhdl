#!/bin/sh
ghdl -r testbench --vcd=testbench.vcd --stop-time=150ns
gtkwave testbench.vcd
