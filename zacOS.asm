	org 0x7c00
	jmp short start
	nop
bsOEM	db "OS423 v.0.1"               ; OEM String

start:
	
;;cls
	mov ah,06h		;Function 06h (scroll screen)
	mov al,0		;Scroll all lines
	mov bh,0ah		;Attribute (lightgreen on black) 
	mov ch,0		;Upper left row is zero
	mov cl,0		;Upper left column is zero
	mov dh,24		;Lower left row is 24
	mov dl,79		;Lower left column is 79
	int 10h			;BIOS Interrupt 10h (video services)
				;Colors from 0: Black Blue Green Cyan Red Magenta Brown White
				;Colors from 8: Gray LBlue LGreen LCyan LRed LMagenta Yellow BWhite

;;printHello
	mov ah,13h		;Function 13h (display string), XT machine only
	mov al,1		;Write mode is zero: cursor stay after last char
	mov bh,0		;Use video page of zero
	mov bl,0ah		;Attribute (lightgreen on black)
	mov cx,mlen		;Character string length
	mov dh,9		;Position on row 9 
	mov dl,29		;And column 29 
	lea bp,[msg] 		;Load the offset address of string into BP, es:bp
					;Same as mov bp, msg  
	int 10h

	int 20h
	
	;32 is space
	;205 is double horizontal
	;186 is double vertical 
	;201 is top left corner
	;200 is bot left corner 
	;188 is bot right corner
	;187 is top right corner
	;30 across

	

msg db 201,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,187,10,13,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,186,32,'Zac',39,'s OS version 0.1',32,186,10,13,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,200,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,188,10,13,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,'$'
mlen equ $-msg

padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa		;signature (optional)
