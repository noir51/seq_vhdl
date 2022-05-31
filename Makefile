
include config.mk

SRC = counter.vhd decoder.vhd mux81.vhd toplevel.vhd
TB = testbench.vhd

all: options circuit

options:
	@echo Build options:
	@echo "CFLAGS = ${CFLAGS}"
	@echo "CC = ${CC}"

circuit: ${OBJ}
	${CC} -a ${CFLAGS} ${SRC} ${TB}
	${CC} -e ${CFLAGS} testbench

clean:
	rm -f *.o
	rm -f *.cf
	rm -f ./testbench
	rm -f testbench.vcd

simulate:
	./simulation.sh

.PHONY: all options circuit clean simulate
