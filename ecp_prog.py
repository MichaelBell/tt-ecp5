# ECP5 programmer for TT demo board
from machine import Pin, PWM
import rp2

@rp2.asm_pio(out_shiftdir=0, autopull=True, pull_thresh=8, autopush=True, push_thresh=8, sideset_init=(rp2.PIO.OUT_LOW,), out_init=(rp2.PIO.OUT_LOW,))
def spi_cpha0():
    out(pins, 1)             .side(0x0)
    in_(pins, 1)             .side(0x1)

class PIOSPI:
    def __init__(self, sm_id, pin_mosi, pin_miso, pin_sck, freq=1000000):
        self._sm = rp2.StateMachine(sm_id, spi_cpha0, freq=2*freq, sideset_base=Pin(pin_sck), out_base=Pin(pin_mosi), in_base=Pin(pin_miso))
        self._sm.active(1)
        Pin(pin_miso, Pin.IN)

    @micropython.native
    def write(self, wdata):
        first = True
        for b in wdata:
            self._sm.put(b, 24)
            if not first:
                self._sm.get()
            else:
                first = False
        self._sm.get()
        
    def read(self, n):
        return self.write_read_blocking([0,]*n)

    @micropython.native
    def readinto(self, rdata):
        self._sm.put(0)
        for i in range(len(rdata)-1):
            self._sm.put(0)
            rdata[i] = self._sm.get()
        rdata[-1] = self._sm.get()

    @micropython.native
    def write_read_blocking(self, wdata):
        rdata = bytearray(len(wdata))
        i = -1
        for b in wdata:
            self._sm.put(b, 24)
            if i >= 0:
                rdata[i] = self._sm.get()
            i += 1
        rdata[i] = self._sm.get()
        return rdata

#sel = Pin(0, Pin.OUT, value=1)
#spi = PIOSPI(0, 2, 3, 1, freq=10000000)

def program(filename):
    file = open(filename, "rb")
    
    rst = Pin(2, Pin.OUT, value=1)
    rst.off()
    rst.on()
    
    sel = Pin(20, Pin.OUT, value=1)
    spi = PIOSPI(1, 18, 5, 4, freq=1000000)

    print("ECP ID")
    buf = bytearray(4)
    sel.off()
    spi.write(b'\xE0\x00\x00\x00') # READ_ID
    spi.readinto(buf)
    sel.on()
    for b in buf: print("%02x " % (b,), end="")
    print()

    if buf == b"\x41\x11\x10\x43":
        print("OK")

        sel.off()
        spi.write(b'\x3C\x00\x00\x00') # LSC_READ_STATUS
        spi.readinto(buf)
        sel.on()
        for b in buf: print("%02x " % (b,), end="")
        print()

        sel.off()
        spi.write(b'\xC6\x00\x00\x00') # ISC_ENABLE
        sel.on()
        
        if True:
            bitbuf = bytearray(4096)
            sel.off()
            spi.write(b'\x7A\x00\x00\x00') # LSC_BITSTREAM_BURST

            while True:
                num_bytes = file.readinto(bitbuf)
                if num_bytes == 0:
                    break
                elif num_bytes == 4096:
                    spi.write(bitbuf)
                else:
                    spi.write(bitbuf[:num_bytes])
                print(".", end="")
            sel.on()

        sel.off()
        spi.write(b'\x3C\x00\x00\x00') # LSC_READ_STATUS
        spi.readinto(buf)
        sel.on()
        for b in buf: print("%02x " % (b,), end="")
        print()

        sel.off()
        spi.write(b'\x26\x00\x00\x00') # ISC_DISABLE
        sel.on()

def execute(filename, clk_hz=25000000):
    program(filename)
    pwm=PWM(Pin(0), freq=clk_hz, duty_u16=32767)
