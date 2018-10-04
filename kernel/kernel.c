#include <multiboot.h>
#include <system.h>
#include <printf.h>
#include <gdt.h>
#include <idt.h>
#include <tss.h>
#include <vga.h>
#include <timer.h>
#include <asciiart.h>
#include <pmm.h>
#include <paging.h>
#include <kheap.h>
#include <pci.h>
#include <ata.h>
#include <vfs.h>
#include <string.h>
#include <ext2.h>
#include <process.h>
#include <usermode.h>
#include <syscall.h>
#include <elf_loader.h>
#include <vesa.h>
#include <bitmap.h>
#include <compositor.h>
#include <mouse.h>
#include <keyboard.h>
#include <font.h>
#include <rtc.h>
#include <rtl8139.h>
#include <ethernet.h>
#include <ip.h>
#include <udp.h>
#include <dhcp.h>
#include <serial.h>
#include <blend.h>
#include <spinlock.h>


void init()
{
	video_init();
}

_start()
{
  init();
}
