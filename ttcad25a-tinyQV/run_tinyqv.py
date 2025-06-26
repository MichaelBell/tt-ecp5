import time
import sys
import rp2
import gc
import machine
from machine import UART, Pin, PWM, SPI

from ttcontrol import *

from pio_spi import PIOSPI
import flash_prog
import ecp_prog

@rp2.asm_pio(autopush=True, push_thresh=8, in_shiftdir=rp2.PIO.SHIFT_LEFT,
             autopull=True, pull_thresh=8, out_shiftdir=rp2.PIO.SHIFT_RIGHT,
             out_init=(rp2.PIO.OUT_HIGH, rp2.PIO.OUT_HIGH, rp2.PIO.IN_HIGH, rp2.PIO.OUT_HIGH,
                       rp2.PIO.IN_HIGH, rp2.PIO.IN_HIGH, rp2.PIO.OUT_HIGH, rp2.PIO.OUT_HIGH),
             sideset_init=(rp2.PIO.OUT_HIGH))
def qspi_read():
    out(x, 8).side(1)
    out(y, 8).side(1)
    out(pindirs, 8).side(1)
    
    label("cmd_loop")
    out(pins, 8).side(0)
    jmp(x_dec, "cmd_loop").side(1)
    
    out(pindirs, 8).side(0)
    label("data_loop")
    in_(pins, 8).side(1)
    jmp(y_dec, "data_loop").side(0)
    
    out(pins, 8).side(1)
    out(pindirs, 8).side(1)

@rp2.asm_pio(autopush=True, push_thresh=32, in_shiftdir=rp2.PIO.SHIFT_RIGHT)
def pio_capture():
    in_(pins, 8)
    
def spi_cmd(spi, data, sel, dummy_len=0, read_len=0):
    dummy_buf = bytearray(dummy_len)
    read_buf = bytearray(read_len)
    
    sel.off()
    spi.write(bytearray(data))
    if dummy_len > 0:
        spi.readinto(dummy_buf)
    if read_len > 0:
        spi.readinto(read_buf)
    sel.on()
    
    return read_buf

def setup_flash():
    spi = PIOSPI(2, Pin(GPIO_UIO[1]), Pin(GPIO_UIO[2]), Pin(GPIO_UIO[3]), freq=10000000)

    flash_sel = Pin(GPIO_UIO[0], Pin.OUT)
    ram_a_sel = Pin(GPIO_UIO[6], Pin.OUT)
    ram_b_sel = Pin(GPIO_UIO[7], Pin.OUT)
    
    flash_sel.on()
    ram_a_sel.on()
    ram_b_sel.on()    
    
    # Leave CM mode if in it
    spi_cmd(spi, [0xFF], flash_sel)
    spi._sm.active(0)
    del spi

    sm = rp2.StateMachine(0, qspi_read, 16_000_000, in_base=Pin(GPIO_UIO[0]), out_base=Pin(GPIO_UIO[0]), sideset_base=Pin(GPIO_UIO[3]))
    sm.active(1)
    
    # Read 1 byte from address 0 to get into continuous read mode
    num_bytes = 8
    buf = bytearray(num_bytes*2 + 4)
    
    sm.put(8+6+2-1)     # Command + Address + Dummy - 1
    sm.put(num_bytes*2 + 4 - 1) # Data + Dummy - 1
    sm.put(0b11111111)  # Directions
    
    # RAM_B_SEL, RAM_A_SEL, SD3, SD2, SCK, SD1, SD0, CS
    sm.put(0b11000010)  # Command
    sm.put(0b11000010)
    sm.put(0b11000010)
    sm.put(0b11000000)
    sm.put(0b11000010)
    sm.put(0b11000000)
    sm.put(0b11000010)
    sm.put(0b11000010)
    
    sm.put(0b11000000)  # Address
    sm.put(0b11000000)
    sm.put(0b11000000)
    sm.put(0b11000000)
    sm.put(0b11000000)
    sm.put(0b11000000)
    sm.put(0b11100100) 
    sm.put(0b11100100)
    
    sm.put(0b11001001)  # Directions
    
    for i in range(num_bytes*2 + 4):
        buf[i] = sm.get()
        if i >= 4:
            d = buf[i]
            nibble = ((d >> 1) & 1) | ((d >> 1) & 2) | ((d >> 2) & 0x4) | ((d >> 2) & 0x8)
            print("%01x" % (nibble,), end="")
    print()
        
    sm.put(0b11111111)
    sm.put(0b11001001)  # Directions
    sm.active(0)
    del sm
    
    flash_sel = Pin(GPIO_UIO[0], Pin.OUT)
    ram_a_sel = Pin(GPIO_UIO[6], Pin.OUT)
    ram_b_sel = Pin(GPIO_UIO[7], Pin.OUT)
    
    flash_sel.on()
    ram_a_sel.on()
    ram_b_sel.on()    

def setup_ram():
    spi = PIOSPI(2, Pin(GPIO_UIO[1]), Pin(GPIO_UIO[2]), Pin(GPIO_UIO[3]), freq=10000000)

    flash_sel = Pin(GPIO_UIO[0], Pin.OUT)
    ram_a_sel = Pin(GPIO_UIO[6], Pin.OUT)
    ram_b_sel = Pin(GPIO_UIO[7], Pin.OUT)

    flash_sel.on()
    ram_a_sel.on()
    ram_b_sel.on()
    
    for sel in (ram_a_sel, ram_b_sel):
        spi_cmd(spi, [0x35], sel)
        
    spi._sm.active(0)
    del spi        

def run(query=True, stop=True):
    machine.freq(128_000_000)

    if query:
        input("Reset? ")

    # Pull up UART RX
    Pin(GPIO_UI_IN[7], Pin.IN, pull=Pin.PULL_UP)
    
    # All other inputs pulled low
    for i in range(7):
        Pin(GPIO_UI_IN[i], Pin.IN, pull=Pin.PULL_DOWN)

    clk = Pin(GPIO_PROJECT_CLK, Pin.OUT, value=0)
    rst_n = Pin(GPIO_PROJECT_RST_N, Pin.OUT, value=1)
    for i in range(2):
        clk.on()
        clk.off()
    rst_n.off()
    
    clk.on()
    time.sleep(0.001)
    clk.off()
    time.sleep(0.001)

    setup_flash()
    setup_ram()    

    flash_sel = Pin(GPIO_UIO[0], Pin.OUT)
    qspi_sd0  = Pin(GPIO_UIO[1], Pin.OUT)
    qspi_sd1  = Pin(GPIO_UIO[2], Pin.OUT)
    qspi_sck  = Pin(GPIO_UIO[3], Pin.OUT)
    qspi_sd2  = Pin(GPIO_UIO[4], Pin.OUT)
    qspi_sd3  = Pin(GPIO_UIO[5], Pin.OUT)
    ram_a_sel = Pin(GPIO_UIO[6], Pin.OUT)
    ram_b_sel = Pin(GPIO_UIO[7], Pin.OUT)

    qspi_sck.off()
    flash_sel.off()
    ram_a_sel.off()
    ram_b_sel.off()
    qspi_sd0.on()
    qspi_sd1.off()
    qspi_sd2.off()
    qspi_sd3.off()

    for i in range(10):
        clk.off()
        time.sleep(0.001)
        clk.on()
        time.sleep(0.001)

    Pin(GPIO_UIO[0], Pin.IN, pull=Pin.PULL_UP)
    Pin(GPIO_UIO[1], Pin.IN, pull=None)
    Pin(GPIO_UIO[2], Pin.IN, pull=None)
    Pin(GPIO_UIO[3], Pin.IN, pull=None)
    Pin(GPIO_UIO[4], Pin.IN, pull=None)
    Pin(GPIO_UIO[5], Pin.IN, pull=None)
    Pin(GPIO_UIO[6], Pin.IN, pull=Pin.PULL_UP)
    Pin(GPIO_UIO[7], Pin.IN, pull=Pin.PULL_UP)
    
    rst_n.on()
    time.sleep(0.001)
    clk.off()

    sm = rp2.StateMachine(1, pio_capture, 64_000_000, in_base=Pin(21))

    capture_len=1280
    buf = bytearray(capture_len)

    rx_dma = rp2.DMA()
    c = rx_dma.pack_ctrl(inc_read=False, treq_sel=5) # Read using the SM0 RX DREQ
    sm.restart()
    sm.exec("wait(%d, gpio, %d)" % (1, GPIO_UIO[3]))
    rx_dma.config(
        read=0x5020_0024,        # Read from the SM1 RX FIFO
        write=buf,
        ctrl=c,
        count=capture_len//4,
        trigger=True
    )
    sm.active(1)

    if query:
        input("Start? ")

    #uart = UART(1, baudrate=57600, tx=Pin(GPIO_UI_IN[7]), rx=Pin(GPIO_UO_OUT[0]))
    time.sleep(0.001)
    clk = PWM(Pin(GPIO_PROJECT_CLK), freq=32_000_000, duty_u16=32768)

    # Wait for DMA to complete
    while rx_dma.active():
        time.sleep_ms(1)
        
    sm.active(0)
    del sm

    if not stop:
        return

    if query:
        input("Stop? ")
    
    del clk
    rst_n.init(Pin.IN, pull=Pin.PULL_DOWN)
    clk = Pin(Pin.IN, pull=Pin.PULL_DOWN)

    if False:
        while True:
            data = uart.read(16)
            if data is not None:
                for d in data:
                    if d > 0 and d <= 127:
                        print(chr(d), end="")

        for i in range(len(buf)):
            print("%02x " % (buf[i],), end = "")
            if (i & 7) == 7:
                print()

    if False:
        for j in range(8):
            print("%02d: " % (j+21,), end="")
            for d in buf:
                print("-" if (d & (1 << j)) != 0 else "_", end = "")
            print()

        print("SD: ", end="")
        for d in buf:
            nibble = ((d >> 1) & 1) | ((d >> 1) & 2) | ((d >> 2) & 0x4) | ((d >> 2) & 0x8)
            print("%01x" % (nibble,), end="")
        print()

def execute(filename, tinyqv="/tinyqv.bit"):
    flash_prog.program(filename)
    gc.collect()
    ecp_prog.program(tinyqv)
    gc.collect()
    run(query=False, stop=True)
