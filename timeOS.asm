[BITS 16]               ;Set code generation to 16 bit mode

[ORG 100H]		;set addressing to begin at 100H

start:
  call cls	;call routine to clear screen
  call dspmsg	;call routine to display message

  call date
  call cvtmo
  call cvtday
  call cvtcent
  call cvtyear
  call dspdate
  
  call time
  call cvthrs
  call cvtmin
  call cvtsec
  call dsptime
  call L1;
  int 20h ;halt operation (VERY IMPORTANT!!!)

cls:			 
  mov ah,06h	;function 06h (Scroll Screen)
  mov al,0	;scroll all lines
  mov bh,1FH	;Attribute (bright white on blue)
  mov ch,0	;Upper left row is zero
  mov cl,0	;Upper left column is zero
  mov dh,24	;Lower left row is 24
  mov dl,79	;Lower left column is 79
  int 10H	;BIOS Interrupt 10h (video services)
  ret

mov cx, 100
L1:
     push cx

     ;MOV AX, @DATA                ; initialize DS
     MOV DS, AX


     ;mov BX,offset time           ; BX=offset address of string TIME

     call time
     call cvthrs
     call cvtmin
     call cvtsec
     call dsptime

     call cls 

     ;MOV DX,offset time           ; DX=offset address of string PROMPT
     MOV AH, 09H                  ; print the string PROMPT
     ;INT 21H                                          

     MOV AH, 4CH                  ; return control to DOS
     ;INT 21H

     pop cx

     loop L1

dspmsg: 
  mov ah,13h	;function 13h (Display String)
  mov al,0	;Write mode is zero
  mov bh,0	;Use video page of zero
  mov bl,0fh	;Attribute (bright white on bright blue)
  mov cx,8	;Character string is 25 long
  mov dh,3	;position on row 3
  mov dl,0	;and column 28
  push ds		;put ds register on stack
  pop es		;pop it into es register
  lea bp,[msg]	;load the offset address of string into BP
  int 10H
  ret
 	
msg: db 'My name :D'

date:
;Get date from the system
mov ah,04h	 ;function 04h (get RTC date)
int 1Ah		;BIOS Interrupt 1Ah (Read Real Time Clock)
ret

;CH - Century
;CL - Year
;DH - Month
;DL - Day

cvtmo:
;Converts the system date from BCD to ASCII
mov bh,dh ;copy contents of month (dh) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [dtfld],bh
mov bh,dh
and bh,0fh
add bh,30h
mov [dtfld + 1],bh
ret

cvtday:
mov bh,dl ;copy contents of day (dl) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [dtfld + 3],bh
mov bh,dl
and bh,0fh
add bh,30h
mov [dtfld + 4],bh
ret

cvtcent:
mov bh,ch ;copy contents of century (ch) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [dtfld + 6],bh
mov bh,ch
and bh,0fh
add bh,30h
mov [dtfld + 7],bh
ret

cvtyear:
mov bh,cl ;copy contents of year (cl) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [dtfld + 8],bh
mov bh,cl
and bh,0fh
add bh,30h
mov [dtfld + 9],bh
ret

dtfld: db '00/00/0000'

dspdate:
;Display the system date
mov ah,13h ;function 13h (Display String)
mov al,0 ;Write mode is zero
mov bh,0 ;Use video page of zero
mov bl,0Fh ;Attribute
mov cx,10 ;Character string is 10 long
mov dh,4 ;position on row 4
mov dl,0 ;and column 28
push ds ;put ds register on stack
pop es ;pop it into es register
lea bp,[dtfld] ;load the offset address of string into BP
int 10H
ret

time:
;Get time from the system
mov ah,02h
int 1Ah
ret

;CH - Hours
;CL - Minutes
;DH - Seconds

cvthrs:
;Converts the system time from BCD to ASCII
mov bh,ch ;copy contents of hours (ch) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [tmfld],bh
mov bh,ch
and bh,0fh
add bh,30h
mov [tmfld + 1],bh
ret

cvtmin:
mov bh,cl ;copy contents of minutes (cl) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [tmfld + 3],bh
mov bh,cl
and bh,0fh
add bh,30h
mov [tmfld + 4],bh
ret

cvtsec:
mov bh,dh ;copy contents of seconds (dh) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [tmfld + 6],bh
mov bh,dh
and bh,0fh
add bh,30h
mov [tmfld + 7],bh
ret

tmfld: db '00:00:00'

dsptime:
;Display the system time
mov ah,13h ;function 13h (Display String)
mov al,0 ;Write mode is zero
mov bh,0 ;Use video page of zero
mov bl,0Fh ;Attribute
mov cx,8 ;Character string is 8 long
mov dh,5 ;position on row 5
mov dl,0 ;and column 28
push ds ;put ds register on stack
pop es ;pop it into es register
lea bp,[tmfld] ;load the offset address of string into BP
int 10H
ret

int 20H
