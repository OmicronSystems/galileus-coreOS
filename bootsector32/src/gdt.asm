;
;	GLOBAL DESCRIPTOR TABLE
;	32 BIT MODE BOOT SECTOR - [SEP 26 2018]
;	Copyright 2018 Francesco Grecucci and Omicron Systems Organization
;	NO WARRANTY. Licensed under the GNU General Public License version 2
;   ____  __  __ _____ _____ _____   ____  _   _    _______     _______ _______ ______ __  __  _____ 
;  / __ \|  \/  |_   _/ ____|  __ \ / __ \| \ | |  / ____\ \   / / ____|__   __|  ____|  \/  |/ ____|
; | |  | | \  / | | || |    | |__) | |  | |  \| | | (___  \ \_/ / (___    | |  | |__  | \  / | (___  
; | |  | | |\/| | | || |    |  _  /| |  | | . ` |  \___ \  \   / \___ \   | |  |  __| | |\/| |\___ \ 
; | |__| | |  | |_| || |____| | \ \| |__| | |\  |  ____) |  | |  ____) |  | |  | |____| |  | |____) |
;  \____/|_|  |_|_____\_____|_|  \_\\____/|_| \_| |_____/   |_| |_____/   |_|  |______|_|  |_|_____/ 


; GDT
gdt_start:

gdt_null:
    dd 0x0  ; 'dd' means define double word (i.e. 4 bytes)
    dd 0x0

gdt_code:
    ; base=0x0, limit=0xfffff.
    ; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
    ; type flags:(code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
    ; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b
    dw 0xffff       ; Limit (bits 0-15)
    dw 0x0          ; Base (bits 0-15)
    db 0x0          ; Base (bits 16-23)
    db 10011010b    ; 1st flags, type flags
    db 11001111b    ; 2nd flags, Limit (bits 16-19)
    db 0x0          ; Base (bits 24-31)
    
gdt_data:   
    ; Same as the code segment except for the type flags:
    ; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
    dw 0xffff       ; Limit (bits 0-15)
    dw 0x0          ; Base (bits 0-15)
    db 0x0          ; Base (bits 16-23)
    db 10011010b    ; 1st flags, type flags
    db 11001111b    ; 2nd flags, Limit (bits 16-19)
    db 0x0          ; Base (bits 24-31)
 
gdt_end:            ; The reason for putting a label at the end of the
                    ; GDT is so we can have the assembler calculate
                    ; the size of the GDT for the GDT descriptor (below)

; GDT DESCRIPTOR
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size of our GDT, always less one
                                ; of the true size
    dd gdt_start                ; Start address of GDT
    
; CONSTRAINTS

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start                    