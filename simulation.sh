#!/bin/sh
ghdl -r testbench --vcd=testbench.vcd --stop-time=500ns
gtkwave testbench.vcd
