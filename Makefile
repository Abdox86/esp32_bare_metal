# /**
#  * @author: Abdulfatah M. Alturshani
#  * @cretid: to vivonomicon blog
#  *          https://vivonomicon.com/2019/03/30/getting-started-with-bare-metal-esp32-programming/
#  *          
#  *          aslo to  Sergey Lyubka
#  *          https://github.com/cpq/mdk 
# */


TARGET = main

DEVICE = esp32

TOOLCHAIN = xtensa-esp32-elf-

CFLAGS_PLATFORM  = -mlongcalls -mtext-section-literals -fstrict-volatile-bitfields
ASFLAGS_PLATFORM = $(CFLAGS_PLATFORM)
LDFLAGS_PLATFORM = $(CFLAGS_PLATFORM)

# Project Build Tools
CC = $(TOOLCHAIN)gcc
LD = $(TOOLCHAIN)ld
DP = $(TOOLCHAIN)objdump
OC = $(TOOLCHAIN)objcopy
OS = $(TOOLCHAIN)size

#linker script file
LDSCRIPT = ./esp32.ld

# Set C/LD/AS flags.
CFLAGS += $(INC) -Wall -Werror -std=gnu11 -nostdlib $(CFLAGS_PLATFORM) $(COPT)
# (Allow access to the same memory location w/ different data widths.)
CFLAGS += -fno-strict-aliasing
CFLAGS += -fdata-sections -ffunction-sections
#CFLAGS += -Os
CFLAGS += -Os -g -O0
LDFLAGS += -nostdlib -T$(LDSCRIPT) -Wl,-Map=$@.map -Wl,--cref -Wl,--gc-sections
LDFLAGS += $(LDFLAGS_PLATFORM)
LDFLAGS += -lm -lc -lgcc
ASFLAGS += -c -O0 -Wall -fmessage-length=0
ASFLAGS += $(ASFLAGS_PLATFORM)

# Source files
C_SRC = \
./boot.c \
./main.c \

# object files
OBJS += $(C_SRC:.c=.o)

# Set the first rule in the file to 'make all'
.PHONY: all
all: main.elf

# Rules to build files.
%.o: %.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

main.elf: $(OBJS)
	$(CC) $^ $(LDFLAGS) -o $@

# Target to clean build artifacts.
.PHONY: clean
clean:
	-rm -f $(OBJS)
	-rm -f ./main.bin
	-rm -f ./main.elf ./main.elf.map

# Target to format build artifacts.
.PHONY: format
format:
	-esptool.py --chip esp32 elf2image --flash_mode="dio" --flash_freq "40m" --flash_size "4MB" -o main.bin main.elf

# Target to flash 
.PHONY: flash
flash:
	-esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 115200 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0x1000 main.bin

# Dump
.PHONY: dump
dump:
	-$(DP) -d -S ./${TARGET}.elf