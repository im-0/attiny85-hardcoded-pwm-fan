.POSIX:
.SUFFIXES: .c .o

DEVICE       = attiny85
CLOCK        = 8000000
FUSES        = -U lfuse:w:0x62:m -U hfuse:w:0xdf:m -U efuse:w:0xff:m

CC           = avr-gcc
OBJCOPY      = avr-objcopy
AVR_SIZE     = avr-size
AVRDUDE      = avrdude
AVRDUDE_OPTS = -cbuspirate -xascii -xnopagedwrite -xnopagedread -P/dev/ttyACM0
BASE_CFLAGS  = -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -std=gnu99 -Wall -Wextra
CFLAGS       = -Os

# 255 == FAN off.
# 0 == FAN at full speed.
DUTY_CYCLE   = 128

all: hpwm.hex

.c.o:
	$(CC) -DDUTY_CYCLE=$(DUTY_CYCLE) $(BASE_CFLAGS) $(CFLAGS) -c -o $(@) $(<)

hpwm.elf: main.o
	$(CC) $(BASE_CFLAGS) $(CFLAGS) $(BASE_LDFLAGS) $(LDFLAGS) -o $(@) $(^)

hpwm.hex: hpwm.elf
	$(OBJCOPY) -j .text -j .data -O ihex hpwm.elf hpwm.hex
	$(AVR_SIZE) --format=avr --mcu=$(DEVICE) hpwm.elf

flash_fw: hpwm.hex
	$(AVRDUDE) -p$(DEVICE) $(AVRDUDE_OPTS) -U flash:w:$(<):i

flash_fuses:
	$(AVRDUDE) -p$(DEVICE) $(AVRDUDE_OPTS) $(FUSES)

clean:
	rm -f *.o
	rm -f *.elf
	rm -f *.hex
