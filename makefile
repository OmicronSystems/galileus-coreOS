#
#	BISMUTH MAKEFILE
#	CORE OS KERNEL DEVELOPMENT PROJECT [OCT 03 2018] - Version 0.73a
#	Copyright 2018 Francesco Grecucci and Omicron Systems Organization
#	NO WARRANTY. Licensed under the GNU General Public License version 2
#   ____  __  __ _____ _____ _____   ____  _   _    _______     _______ _______ ______ __  __  _____ 
#  / __ \|  \/  |_   _/ ____|  __ \ / __ \| \ | |  / ____\ \   / / ____|__   __|  ____|  \/  |/ ____|
# | |  | | \  / | | || |    | |__) | |  | |  \| | | (___  \ \_/ / (___    | |  | |__  | \  / | (___  
# | |  | | |\/| | | || |    |  _  /| |  | | . ` |  \___ \  \   / \___ \   | |  |  __| | |\/| |\___ \ 
# | |__| | |  | |_| || |____| | \ \| |__| | |\  |  ____) |  | |  ____) |  | |  | |____| |  | |____) |
#  \____/|_|  |_|_____\_____|_|  \_\\____/|_| \_| |_____/   |_| |_____/   |_|  |______|_|  |_|_____/ 

# Automatically generates lists of sources using wildcards.
C_SOURCES = $(wildcard kernel/*.c drv/*c)
HEADERS = $(wildcard kernel/*.h drv/*h)

# TODO: Make sources dep on all header files.

# Convert the *.c filenames to *.o to give a list of objects files to build
OBJ = ${C_SOURCES:.c=.o}

# Default build target
all: bismuth.img

# This is the actual disk image that the compupter loads
# which is the combination of our compiled bootsector and the kernel
bismuth.img: boot/boot.bin kernel.bin
	cat $^ > bismuth.img

# This builds the binary of our kernel from two objects files:
# - the kernel_entry, which jumps to main() on our kernel
# - the compiled C kernel
kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

# Generic rule for compiling C code to an object file
# For simplicity, C files depend on all header files.
%.o : %.c ${HEADERS}
	gcc -Wall -Wno-int-conversion -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdlib -ffreestanding -I./include -std=gnu99 -g -ggdb -c $< -o $@

# Assemble the kernel_entry.
%.o : %.asm
	nasm $< -f elf64 -o $@

%.bin : %.asm
	nasm $< -f bin -I 'boot/' -o $@
	
clean:
	rm -fr *.bin *.dis *.o  bismuth.img
	rm -fr kernel/*.o boot/*.bin drivers/*.o