;bit16					; 16bit by default
	org 0x7c00
	jmp short start
	nop
bsOEM	db "ZacsOS v.0.1"               ; OEM String

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

;;printWelcomeScreen
	mov ah,13h		;Function 13h (display string), XT machine only
	mov al,1		;Write mode is zero: cursor stay after last char
	mov bh,0		;Use video page of zero
	mov bl,0ah		;Attribute (lightgreen on black)
	mov cx,mlen		;Character string length
	mov dh,0		;Position on row 0
	mov dl,0		;And column 0
	lea bp,[msg]     	;Load the offset address of string into BP, es:bp
	
			        ;Same as mov bp, msg  
	int 10h
	;int 20h

;printTime
	mov ah,13h		;Function 13h (display string), XT machine only
	mov al,1		;Write mode is zero: cursor stay after last char
	mov bh,0		;Use video page of zero
	mov bl,0ah		;Attribute (lightgreen on black)
	mov cx,tlen 		;Character string length
	mov dh,0		;Position on row 0
	mov dl,0		;And column 0
	lea bp,[tst]     	;Load the offset address of string into BP, es:bp
	
			        ;Same as mov bp, msg  
	int 10h
	int 20h
		

;;Variables

tst db 'testing'
tlen equ $-tst

msg db 'Welcome to Zac',39,'s OS ...',10,13,'$'
mlen equ $-msg


padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa			;signature (optional)


