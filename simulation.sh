#!/bin/sh
ghdl -r testbench --vcd=testbench.vcd --stop-time=100ns
gtkwave testbench.vcd
