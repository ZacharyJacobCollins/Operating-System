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
	mov cx,topmlen		;Character string length
	mov dh,0		;Position on row 0
	mov dl,0		;And column 0
	lea bp,[topmsg]     	;Load the offset address of string into BP, es:bp
	
			        ;Same as mov bp, msg  ?
	int 10h			;Output



;printTime
	MOV AH, 2Ch
	INT 21h
	MOV AH, 0Eh
	
	;hours	
	MOV AL, CH
	mov al,ch      ; if ch has 12h
	aam            ; ax will now be 0102h
	or ax,3030h    ; converting into ascii - ax will now become 3132h
		       ; you can now print the value in ax
	mov cx,ax
	mov dl,ch      ; to print on screen
	mov ah,02h
	int 21h
	mov dl,cl	
	int 21h
	
		       ;Print Colon
	MOV DL,':'
	MOV AH,02H
	INT 21H
	

	;minutes
	MOV AL, Cl
	mov al,cl      ; if ch has 12h
	aam            ; ax will now be 0102h
	or ax,3030h    ; converting into ascii - ax will now become 3132h
	; you can now print the value in ax
	mov cx,ax
	mov dl,cl      ; to print on screen
	mov ah,02h
	int 21h
	mov dl,cl	
	int 21h
	
	;Print Colon
	MOV DL,':'
	MOV AH,02H
	INT 21H

		


	
	int 20h			;Terminates program



		

;Variables

topmsg db 10,13,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,10,13, 'Welcome to Zac',39,'s OS ...',10,13,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,10,13
topmlen equ $-topmsg


padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa			;signature (optional)

; int 16h
; 205
; clear screen 10h, 06h
; blinking cursor - is a param insert
; as mbr to start
