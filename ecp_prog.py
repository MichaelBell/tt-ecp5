# ECP5 programmer for TT demo board
from machine import Pin, PWM
import rp2

from pio_spi import PIOSPI

def program(filename):
    file = open(filename, "rb")
    
    rst = Pin(2, Pin.OUT, value=1)
    rst.off()
    rst.on()
    
    sel = Pin(20, Pin.OUT, value=1)
    spi = PIOSPI(1, 18, 5, 4, freq=8000000)

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
