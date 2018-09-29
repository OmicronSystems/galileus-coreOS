;
;	PRINT STRING IN 16 BIT REAL MODE WITH INTERRUPTS
;	32 BIT MODE BOOT SECTOR - [SEP 27 2018]
;	Copyright 2018 Francesco Grecucci and Omicron Systems Organization
;	NO WARRANTY. Licensed under the GNU General Public License version 2
;   ____  __  __ _____ _____ _____   ____  _   _    _______     _______ _______ ______ __  __  _____ 
;  / __ \|  \/  |_   _/ ____|  __ \ / __ \| \ | |  / ____\ \   / / ____|__   __|  ____|  \/  |/ ____|
; | |  | | \  / | | || |    | |__) | |  | |  \| | | (___  \ \_/ / (___    | |  | |__  | \  / | (___  
; | |  | | |\/| | | || |    |  _  /| |  | | . ` |  \___ \  \   / \___ \   | |  |  __| | |\/| |\___ \ 
; | |__| | |  | |_| || |____| | \ \| |__| | |\  |  ____) |  | |  ____) |  | |  | |____| |  | |____) |
;  \____/|_|  |_|_____\_____|_|  \_\\____/|_| \_| |_____/   |_| |_____/   |_|  |______|_|  |_|_____/ 

clrscr:

	mov ah, 00h		; INT 10H 00H: Set Video Mode
	mov al, 3		; 80x25 char
	int 10h
	
	; Make the cursor invisible
	mov ah, 1
    mov ch, 00100000b
    int 10h
	
vga256:
	mov ah, 00h		;INT 10H 00H: Set Video Mode
	mov al, 13h		;640x480 256 colors
	mov ax, 1123h
	int 10h
	ret
	
svga:
	mov ax, 4f02h	; INT 10H 4f02H - Set SuperVGA Video Mode
	mov bx, 108h
	int 10h
	ret
printf:
	pusha
	mov ax, 1300h
	mov bl, 07h