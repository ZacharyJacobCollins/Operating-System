; OS423 Master Boot Record Sector
; ver03 -- by video memory b8000 -- with para
; dh is height dl is length of row of printing

	;bit16			;16bit by default
	org 0x7c00
	jmp short start
	nop
bsOEM	db "OS423 v.0.1"       	;OEM String

start:
		
;;cls:
	mov cl, 0ah			;bh has color attribute
	mov cl, bh			;needs es:bx for display, save bh value	
	
	mov bx,0xb800		;direct video memory access 0xB8000
	mov es,bx
	xor bx,bx			;es:bx : 0xb8000
	mov dh,0			;row from 0 to 24
	mov dl,0			;col from 0 to 79
	
		
.loop:
						;fill with all null characters
	mov byte [es:bx], ''	;char
	inc bx
	mov byte [es:bx], cl
	inc bx

.next:		
	inc dl 				;dl is the length/row movement.
	cmp dl,80			;col 0-79
	jne .loop			;go back to .loop
	mov dl,0		
	inc dh				;go down vertically a line 
	cmp dh,25			;row 0-24
	jne .loop	
	call pause	
	jmp print		; jmp print here

;display 'Hello 423' at (0,0)
 pause:
	push edx;
	push ecx;
	xor cx, cx;
	xor dx, dx;
.out:
	xor dx, dx;
	inc cx;
	cmp cx, 256;
	je .exit;
.inner:
	inc dx;
	nop;
	cmp dx, 256;
	je .out;

.exit:
	pop ecx;
	pop edx;
	ret;

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
	mov byte [es:bx], ah	;char
	inc bx
	mov byte [es:bx], al	;attribute 
	inc bx

.next:	
	inc bp
	dec cx
	jne .loop		

	
	int 20h

msg db 'Hello 423'
mlen equ $-msg	
	
padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa		 	;signature (optional)
