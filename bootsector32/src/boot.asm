;
;	BOOT SECTOR MAIN SOURCE CODE
;	32 BIT MODE BOOT SECTOR - [SEP 29 2018] - Version 0.73a
;	Copyright 2018 Francesco Grecucci and Omicron Systems Organization
;	NO WARRANTY. Licensed under the GNU General Public License version 2
;   ____  __  __ _____ _____ _____   ____  _   _    _______     _______ _______ ______ __  __  _____ 
;  / __ \|  \/  |_   _/ ____|  __ \ / __ \| \ | |  / ____\ \   / / ____|__   __|  ____|  \/  |/ ____|
; | |  | | \  / | | || |    | |__) | |  | |  \| | | (___  \ \_/ / (___    | |  | |__  | \  / | (___  
; | |  | | |\/| | | || |    |  _  /| |  | | . ` |  \___ \  \   / \___ \   | |  |  __| | |\/| |\___ \ 
; | |__| | |  | |_| || |____| | \ \| |__| | |\  |  ____) |  | |  ____) |  | |  | |____| |  | |____) |
;  \____/|_|  |_|_____\_____|_|  \_\\____/|_| \_| |_____/   |_| |_____/   |_|  |______|_|  |_|_____/ 

[org 0x7c00]  

	call clrscr
	call svga
	
	; thanks to https://stackoverflow.com/questions/32701854/boot-loader-doesnt-jump-to-kernel-code/32705076#32705076
	; for solving the triple fault error when jumping into protected mode
	
	xor ax,ax      ; We want a segment of 0 for DS for this question
	mov ds,ax      ;     Set AX to appropriate segment value for your situation
	mov es,ax      ; In this case we'll default to ES=DS
	mov bx,0x8000  ; Stack segment can be any usable memory

	cli            ; Disable interrupts to circumvent bug on early 8088 CPUs
	mov ss,bx      ; This places it with the top of the stack @ 0x80000.
	mov sp,ax      ; Set SP=0 so the bottom of stack will be @ 0x8FFFF
	sti            ; Re-enable interrupts

	cld            ; Set the direction flag to be positive direction
	
	; end of the solution
	
    call switch_to_pm;	; Switch to 32 bit protected mode, we'll never come back here.
	
	jmp $
	
	%include "g:\boot-test\printf16.asm"
    %include "g:\boot-test\gdt.asm"
    %include "g:\boot-test\switchto32.asm"
    %include "g:\boot-test\printf.asm"
	
	
[bits 32]

	BEGIN_PM:
	
	mov ebx, MSG_LOADING
	call print_string_pm
	jmp $
	

	mov ebx, MSG_COPYRIGHT
	call print_string_pm
	jmp $
	
	mov ebx, MSG_LICENSE
	call print_string_pm
	jmp $

	hlt					; Temporary use for testing 
	
	Global Variables
	MSG_LOADING db   'Bismuth Kernel Version 0.73a: Sat Sep 29 2018 17:13:17                          '
	MSG_COPYRIGHT db 'Copyright (c) 2018, Francesco Grecucci and Omicron Systems                      '
	MSG_LICENSE db   'NO WARRANTY. Licensed under the GNU v2 License', 0x00

	times 510-($-$$) db 0
	dw 0xaa55