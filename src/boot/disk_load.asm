;
;	BOOT SECTOR DISK LOAD CODE
;	32 BIT MODE BOOT SECTOR - [OCT 01 2018] - Version 0.73a
;	Copyright 2018 Francesco Grecucci and Omicron Systems Organization
;	NO WARRANTY. Licensed under the GNU General Public License version 2
;   ____  __  __ _____ _____ _____   ____  _   _    _______     _______ _______ ______ __  __  _____ 
;  / __ \|  \/  |_   _/ ____|  __ \ / __ \| \ | |  / ____\ \   / / ____|__   __|  ____|  \/  |/ ____|
; | |  | | \  / | | || |    | |__) | |  | |  \| | | (___  \ \_/ / (___    | |  | |__  | \  / | (___  
; | |  | | |\/| | | || |    |  _  /| |  | | . ` |  \___ \  \   / \___ \   | |  |  __| | |\/| |\___ \ 
; | |__| | |  | |_| || |____| | \ \| |__| | |\  |  ____) |  | |  ____) |  | |  | |____| |  | |____) |
;  \____/|_|  |_|_____\_____|_|  \_\\____/|_| \_| |_____/   |_| |_____/   |_|  |______|_|  |_|_____/ 

; load DH sectors in ES:BX from drive DL

disk_load:
	push dx				; Store DX on stack so later we can recall
						; how many sectors were request to be read,
						; even if it is altered in the meantime	
	mov ah, 0x02		; BIOS read sector function
	mov al, dh			; Read DH sectors
	mov ch, 0x00		; Select cylinder 0
	mov dh, 0x00		; Select head 0
	mov cl, 0x02		; Start reading from second sector ( i.e.
						; after the boot sector )
	int 0x13			; BIOS interrupt
	
	jc disk_error		; Jump if error ( i.e. carry flag set )
	
	pop dx				; Restore DX from the stack
	cmp dh, al			; if AL ( sectors read ) != DH ( sectors expected )	
	jne disk_error		;    display error message
	ret
	
disk_error :
	int 10h
	mov ah, 09h
	mov al, 'D'
	mov bl, 0x74
	hlt

