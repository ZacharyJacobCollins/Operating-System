	org 0x7c00
	jmp short start
	nop
bsOEM	db "OS423 v.0.1"               ; OEM String

start:
	
	call cls;
	call printSplash;
	;call keypressclear;
	;call cls;
	;call printDollar;
	call second;
	int 20h;	

second:
  push eax;
  push ebx;

  xor bx, bx;

  mov bx, 0x0012;
  mov es, bx;
  mov bx, 0x1234;

  mov ah, 0x02;
  mov al, 0x01;
  mov ch, 0x01;
  mov cl, 0x02;
  mov dh, 0x00;
  mov dl, 0x00;
  int 0x13;
  jc second;
  jmp 0x0012:0x1234;
  ret;

cls:
	push ebx;	
	push eax;	

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

	pop ebx;	
	pop eax;		; return val to ah, al
	ret;   			; return to calling mode


printDollar:
	mov ah,13h		;Function 13h (display string), XT machine only
  	mov al,1		;Write mode is zero: cursor stay after last char
	mov bh,0		;Use video page of zero
	mov bl,0ah		;Attribute (lightgreen on black)
	mov cx,dollarLen        ;Character string length
	mov dh,0		;Position on row 9 
	mov dl,0		;And column 29 
	lea bp,[dollar] 	;Load the offset address of string into BP, es:bp
				;Same as mov bp, msg  
	int 10h
	ret


keypressclear:
	push eax;
	mov ah, 00h;
	int 16h;
	pop eax;
	ret;


printSplash:
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

	ret;
	
	;32 is space
	;205 is double horizontal
	;186 is double vertical 
	;201 is top left corner
	;200 is bot left corner 
	;188 is bot right corner
	;187 is top right corner
	;30 across
	

; The message to print
msg db 201,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,187,10,13,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,186,32,'Zac',39,'s OS version 0.1',32,186,10,13,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,200,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,205,188,10,13,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,'$'

mlen equ $-msg

dollar db '$'
dollarLen equ $-dollar


padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa		;signature (optional)

