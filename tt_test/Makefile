TARGET = tt_test
TOP = tt_ecp5_wrapper

OBJS += tt_test.v tt_wrapper.v

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
	nextpnr-ecp5 --25k --package CABGA256 --speed 6 --json $< --textcfg $@ --lpf $(TARGET).lpf > nextpnr.log 2>& 1
	@grep Warn nextpnr.log || true
	@grep Error nextpnr.log || true
	@grep "Max frequency.*clk" nextpnr.log | tail -1
	@echo

$(TARGET).bit: $(TARGET)_out.config
	ecppack --svf ${TARGET}.svf $< $@

${TARGET}.svf: ${TARGET}.bit

prog: ${TARGET}.bit
	mpremote mount . + exec "import os; os.chdir('/'); import ecp_prog; ecp_prog.execute('/remote/$(TARGET).bit', 10)"

clean:
	rm -f *.svf *.bit *.config *.ys *.log

.PHONY: all prog clean
