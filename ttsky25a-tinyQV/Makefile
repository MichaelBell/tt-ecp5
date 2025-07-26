TARGET = tinyqv
TOP = tt_ecp5_wrapper
PROG ?= seven

OBJS += tt_wrapper.v ttsky25a-tinyQV/src/*.v ttsky25a-tinyQV/src/user_peripherals/*/*.v ttsky25a-tinyQV/src/user_peripherals/*.v ttsky25a-tinyQV/src/tinyQV/cpu/*.v ttsky25a-tinyQV/src/tinyQV/peri/uart/uart_tx.v

all: ${TARGET}.bit

$(TARGET).ys: $(OBJS)
	yosys -p "synth_ecp5 -top ${TOP} -json $@" $(OBJS) > yosys.log
	@grep Warn yosys.log || true
	@grep Error yosys.log || true
	@grep "   Number of cells" yosys.log
	@grep "     TRELLIS_FF" yosys.log | awk '{sum+=$$2;}END{printf("     TRELLIS_FF* %21d\n", sum);}'
	@grep "     LUT" yosys.log
	@echo	

$(TARGET)_out.config: $(TARGET).ys
	nextpnr-ecp5 --25k --package CABGA256 --speed 6 --json $< --textcfg $@ --lpf tt.lpf > nextpnr.log 2>& 1
	@grep Warn nextpnr.log || true
	@grep Error nextpnr.log || true
	@grep "Max frequency.*clk" nextpnr.log | tail -1
	@echo

$(TARGET).bit: $(TARGET)_out.config
	ecppack --svf ${TARGET}.svf $< $@

${TARGET}.svf: ${TARGET}.bit

prog: ${TARGET}.bit
	mpremote mount . + exec "import os; os.chdir('/'); import run_tinyqv; run_tinyqv.execute('/remote/$(PROG).bin', '/remote/$(TARGET).bit')"

reprog:
	mpremote mount . + exec "import os; os.chdir('/'); import run_tinyqv; run_tinyqv.execute('/remote/$(PROG).bin', None)"

regate: ${TARGET}.bit
	mpremote mount . + exec "import os; os.chdir('/'); import run_tinyqv; run_tinyqv.execute(None, '/remote/$(TARGET).bit')"

clean:
	rm -f *.svf *.bit *.config *.ys *.log

.PHONY: all prog clean
