;
;	PROTECTED MODE SWITCH (FROM 16 BIT TO 32 BIT)
;	32 BIT MODE BOOT SECTOR - [SEP 27 2018]
;	Copyright 2018 Francesco Grecucci and Omicron Systems Organization
;	NO WARRANTY. Licensed under the GNU General Public License version 2
;   ____  __  __ _____ _____ _____   ____  _   _    _______     _______ _______ ______ __  __  _____ 
;  / __ \|  \/  |_   _/ ____|  __ \ / __ \| \ | |  / ____\ \   / / ____|__   __|  ____|  \/  |/ ____|
; | |  | | \  / | | || |    | |__) | |  | |  \| | | (___  \ \_/ / (___    | |  | |__  | \  / | (___  
; | |  | | |\/| | | || |    |  _  /| |  | | . ` |  \___ \  \   / \___ \   | |  |  __| | |\/| |\___ \ 
; | |__| | |  | |_| || |____| | \ \| |__| | |\  |  ____) |  | |  ____) |  | |  | |____| |  | |____) |
;  \____/|_|  |_|_____\_____|_|  \_\\____/|_| \_| |_____/   |_| |_____/   |_|  |______|_|  |_|_____/ 

[bits 16]                       ; 16 BIT MODE

switch_to_pm:
    cli                         ; We must switch of interrupts until we have
                                ; set-up the protected mode interrupt vector
                                ; otherwise interrupts will run riot.
    
    lgdt [gdt_descriptor]       ; Load our global descriptor table, which defines
                                ; the protected mode segments (e.g. for code and data)
    
    mov eax, cr0                ; To make the switch to protected mode, we set the first
    or  eax, 0x1                ; bit of CR0, a control register
	mov cr0, eax
    jmp CODE_SEG:init_pm        ; Make a far jump to the new 32-bit code. 
                                ; This also forces the CPU to flush its cache of
                                ; pre-fetched and real-mode decoded instructions, which
                                ; can cause problems.
                    
[bits 32]                       ; 32 BIT MODE
; Initialise registers and the stack once in PM.

init_pm:
    mov ax, DATA_SEG            ; Nov in PM, our old segments are meaningless,
	mov ds, ax                  ; so we point our segments registers to the
	mov ss, ax