; OS423 Master Boot Record Sector
; ver04 -- cls by int
; 1/5/2016

	;bit16					; 16bit by default
	org 0x7c00
	jmp short start
	nop
bsOEM	db "OS423 v.0.1"               ; OEM String

;==========================================================;
;        cls is done via int ffh, ah=1                     ;
;==========================================================;

start:
	mov  ax,cs
	mov  ds,ax
	mov  es,ax
	call install_syscall ;implment user defined interrupt

	mov  ah,1	;service ah=1
	; set parameters

	mov ch, ''	;char to display
	mov cl, 1eh	;yellow on blue
	int  0xff	;interrupt call

	mov ah, 0
	int 16h

	mov  ah,1	;service ah=1
	; set parameters

	mov ch, ' '	;char to display
	mov cl, 0ah	;lightgreen on black
	int  0xff	;interrupt call

	int 20h


install_syscall:
	push dx
	push es				;backup
	
	xor ax, ax
	mov es, ax			;es set to segment 0000
	cli				;disable interrupt
	mov word [es:0xff*4], _int0xff	;interrupt 0xff
	mov [es:0xff*4+2], cs		;table entry
	sti				;enable interrupt
	
	pop es
	pop dx				;restore

    ret

;==========================================================;
;                 Interrupt Service ffh                    ;
;==========================================================;

_int0xff:
	pusha				;save all
	cmp ah,0x01			;service ah=1
	je  _int0xff_ser0x01
	jmp _int0xff_end		;done

;==========================================================;
;	Interrupt Service ffh ah=0x01			   ;
;	ch=char to display cl=color attr		   ;
;==========================================================;

_int0xff_ser0x01:

;;cls
	mov bh, 0ah		; bh has color attribute
	mov cl, bh		; needs es:bx for display, save bh value	
	
	mov bx,0xb800		;direct video memory access 0xB8000
	mov es,bx
	xor bx,bx		;es:bx : 0xb8000
	mov dh,0		;row from 0 to 24
	mov dl,0		;col from 0 to 79
		
	.loop:
		mov byte [es:bx], ' '	;char
		inc bx
		mov byte [es:bx], cl
		inc bx

	.next:		
		inc dl
		cmp dl,80		;col 0-79
		jne .loop
		mov dl,0
		inc dh
		cmp dh,25		;row 0-24
		jne .loop		
			
	; display 'Hello 423' at (0,0)

	print:
		mov bl, 0ah		;color
		mov cx, mlen
		lea bp, [msg]

		mov al, bl		;save color
		mov bx,0xb800	;direct video memory access 0xB8000
		mov es,bx
		xor bx,bx
					
	.loop:
		mov ah, byte [ds:bp]
		mov byte [es:bx], ah		;char

		cmp byte [es:bx], 57
		je .makeZero

		cmp byte [es:bx], 57
		jle .addOne

		cmp byte [es:bx], 90
		jle .lowercase

		cmp byte [es:bx], 122
		jle .uppercase 

	.addOne: 
		add byte [es:bx], 1
		jmp .default

	.makeZero
		mov byte [es:bx], '0'
		jmp .default		

	.uppercase: 
		AND byte [es:bx], 0xDF	;Uppercase the letter
		jmp .default

	.lowercase: 
		OR byte [es:bx], 20h	;Lowercase the letter
		jmp .default


	.default: 
		inc bx	
		mov byte [es:bx], al	;attribute 
		sub al, 20H				;blinking virus
		inc bx

		; jle
		; jl
		; jge
		; jg

	.next:	
		inc bp
		dec cx
		jne .loop		
		int 20h


	msg db 'Hello 429'
	mlen equ $-msg	


	jmp _int0xff_end		;done

;==========================================================
; Done
;==========================================================

_int0xff_end:
	popa				;restore
	iret				;must use iret instead ret

	
padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa		;signature (optional)