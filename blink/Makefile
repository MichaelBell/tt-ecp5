TARGET=blink
TOP=blink

OBJS+=blink.v

all: ${TARGET}.bit

$(TARGET).ys: $(OBJS)
	yosys -p "synth_ecp5 -top ${TOP} -json $@" $(OBJS)

$(TARGET)_out.config: $(TARGET).ys
	nextpnr-ecp5 --25k --package CABGA256 --speed 6 --json $< --textcfg $@ --lpf $(TARGET).lpf --freq 65

$(TARGET).bit: $(TARGET)_out.config
	ecppack --svf ${TARGET}.svf $< $@

${TARGET}.svf: ${TARGET}.bit

prog: ${TARGET}.bit
	openFPGALoader -c digilent_hs2 $(TARGET).bit

clean:
	rm -f *.svf *.bit *.config *.ys *.ys

.PHONY: all prog clean
