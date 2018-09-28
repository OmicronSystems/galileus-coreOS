;
;	BOOT SECTOR MAIN SOURCE CODE
;	32 BIT MODE BOOT SECTOR - [SEP 28 2018]
;	Copyright 2018 Francesco Grecucci and Omicron Systems Organization
;	NO WARRANTY. Licensed under the GNU General Public License version 2
;   ____  __  __ _____ _____ _____   ____  _   _    _______     _______ _______ ______ __  __  _____ 
;  / __ \|  \/  |_   _/ ____|  __ \ / __ \| \ | |  / ____\ \   / / ____|__   __|  ____|  \/  |/ ____|
; | |  | | \  / | | || |    | |__) | |  | |  \| | | (___  \ \_/ / (___    | |  | |__  | \  / | (___  
; | |  | | |\/| | | || |    |  _  /| |  | | . ` |  \___ \  \   / \___ \   | |  |  __| | |\/| |\___ \ 
; | |__| | |  | |_| || |____| | \ \| |__| | |\  |  ____) |  | |  ____) |  | |  | |____| |  | |____) |
;  \____/|_|  |_|_____\_____|_|  \_\\____/|_| \_| |_____/   |_| |_____/   |_|  |______|_|  |_|_____/ 

[org 0x7c00]

	mov bp, 0x9000  ; Set the Stack.
    mov sp, bp
	
	call clrscr
    call switch_to_pm;	; Switch to 32 bit protected mode, we'll never come back here.
	jmp $
	
	%include "g:\boot-test\printf16.asm"
    %include "g:\boot-test\gdt.asm"
    %include "g:\boot-test\switchto32.asm"
    %include "g:\boot-test\printf.asm"
	times 510-($-$$) db 0
	dw 0xaa55
	
[bits 32]