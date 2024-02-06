;coal project phase-2
;21L-5478
;21L-0877
[org 0x0100]
jmp start
message: db 'GAME OVER!',0
message2: db 'SCORE : ',0
message3: db 'TIME : ',0
TNT: db 'TNT'
msg1: db 'ALL RIGHTS RESERVED', 0
msg2: db 'o 2022 GAME CO.,LTD', 0
msg3: db 'Press any key to start the game', 0
varx: dw 37
oldisr: dd 0
yposgem1: dw 0
yposgem2: dw 0
yposgem3: dw 0
xposgem1: dw 0
xposgem2: dw 0
xposgem3: dw 0
xtnt: dw 0
ytnt: dw 0
esccheck: dw 0 ;esc check
collisionCheck: dw 0 ;1-collisionwithbomb, 0-nocollision
score: dw 0
tickcount: dw 0
second: dw 0
;--------------------------------------------------------------
;--------------------------------------------------------------
kbisr: 
 push ax 
 push es 

 in al, 0x60 ; read a char from keyboard port 
 
 cmp al, 0x01 ;check for esc
 jne notesc 
 mov word[esccheck],1;if esc is pressed
 jmp nomatch
 
 notesc:
 
 cmp al, 0x4B ; IF THE LEFT SCANCODE IS FOUND 4b
 jne nextcmp ; no, try next comparison 
 
 CMP word[varx], 2
 JLE nomatch
 SUB WORD[varx], 2 ;yes

 jmp nomatch ; leave interrupt routine 
 
nextcmp:
 cmp al, 0x4D ;IF THE RIGHT SCANCODE IS FOUND 4d
 jne nomatch ; no, leave interrupt routine 
  
 CMP word[varx], 72
 JGE nomatch
 ADD WORD[varx], 2 ;yes
 
nomatch: 


 mov al, 0x20 
 out 0x20, al ; send EOI to PIC 

 pop es 
 pop ax 
 jmp far [cs:oldisr]
 ;iret 
 
;--------------------------------------------------------------
;--------------------------------------------------------------
delay:
push ax
push bx
push cx

mov ax,5
pause3:
mov bx,100
pause2:
mov cx,655
pause1:
dec cx
jne pause1
dec bx
jne pause2
dec ax
jne pause3

pop cx
pop bx
pop ax
ret
;--------------------------------------------------------------
;--------------------------------------------------------------
delay1:
push ax
push bx
push cx

mov ax,5
pause33:
mov bx,60
pause22:
mov cx,6553
pause11:
dec cx
jne pause11
dec bx
jne pause22
dec ax
jne pause33

pop cx
pop bx
pop ax
ret
;------------------------------------------------------
;------------------------------------------------------
; subroutine to print a number at top left of screen takes the number to be printed as its parameter
;------------------------------------------------------
;------------------------------------------------------
printnum: 
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di

mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [bp+4] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits

nextdigitt: 
mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigitt ; if no divide it again
mov di, [bp+6] ; point di to 70th column

nextposs:
pop dx ; remove a digit from the stack
mov dh, 0x07 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextposs ; repeat for all digits on stack

pop di
pop dx
pop cx
pop bx
pop ax 
pop es
pop bp
ret 4
;------------------------------------------------------
; timer interrupt service routine
;------------------------------------------------------
timer:		
push ax
	
inc word [cs:tickcount]; increment tick count
cmp word[cs:tickcount],18
jne timerloop
mov word[cs:tickcount],0
inc word[cs:second]

timerloop:	
mov al, 0x20
out 0x20, al ; end of interrupt

pop ax
iret ; return from interrupt
;--------------------------------------------------------------
;--------------------------------------------------------------
printWords:
 mov ax, 30 
 push ax ; push x position 
 mov ax, 11 
 push ax ; push y position 
 mov ax, 0x09 ; blue on black attribute 
 push ax ; push attribute 
 mov ax, msg1 
 push ax ; push address of message 
 call printstr ; call the printstr subroutine 
 
 mov ax, 30 
 push ax ; push x position 
 mov ax, 12
 push ax ; push y position 
 mov ax, 0x09 ; blue on black attribute 
 push ax ; push attribute 
 mov ax, msg2 
 push ax ; push address of message 
 call printstr ; call the printstr subroutine 

 mov ax, 30 
 push ax ; push x position 
 mov ax, 13
 push ax ; push y position 
 mov ax, 0x09 ; blue on black attribute 
 push ax ; push attribute 
 mov ax, msg3
 push ax ; push address of message 
 call printstr ; call the printstr subroutine 
 ret
;--------------------------------------------------------------
;--------------------------------------------------------------
clrscr:	
push es
push ax
push di
mov ax, 0xb800
mov es, ax
mov di, 0

nextloc:	
mov word [es:di], 0x0720
add di, 2
cmp di, 4000
jne nextloc
pop di
pop ax
pop es
ret
;--------------------------------------------------------------
;--------------------------------------------------------------
printStars:
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 
 ;printing stars
 ;except in first and last line
 mov di,160
stars:
 mov word [es:di], 0x0FFE
 add di, 100
 cmp di, 3838
 jle stars

 
 pop di 
 pop cx
 pop ax
 pop es
 ret
 
;--------------------------------------------------------------
;--------------------------------------------------------------

printStart:
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 
 
 ;printing S
 mov di, 1012
 mov ax, 0x79DC ; space char in normal attribute 
 mov cx, 3 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear

 mov di, 1170
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1332
 mov ax, 0x79DF ; space char in normal attribute 
 mov cx, 2 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1496
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1650
 mov ax, 0x79DF ; space char in normal attribute 
 mov cx, 3 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 
 ;printing T
 mov di, 1020
 mov ax, 0x79DF ; space char in normal attribute 
 mov cx, 3 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1182
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1342
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1502
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1662
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 ;printing A
 mov di, 1030
 mov ax, 0x79DF ; space char in normal attribute 
 mov cx, 2 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear 
 
 mov di, 1188
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1194
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear 
 
 mov di, 1348
 mov ax, 0x79DF ; space char in normal attribute 
 mov cx, 4 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear 
 
 mov di, 1508
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear 
 
 mov di, 1514
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear 
 
 mov di, 1668
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1674
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
;printing R
 mov di, 1038
 mov ax, 0x79DF ; space char in normal attribute 
 mov cx, 3 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1198
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1204
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1358
 mov ax, 0x79DF ; space char in normal attribute 
 mov cx, 3 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1518
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1522
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear 
 
 mov di, 1678
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
  
 mov di, 1684
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 
 ;printing T
 mov di, 1048
 mov ax, 0x79DF ; space char in normal attribute 
 mov cx, 3 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1210
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1370
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear
 
 mov di, 1530
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear 
 
 mov di, 1690
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear 

 mov di, 1690
 mov ax, 0x79DD ; space char in normal attribute 
 mov cx, 1 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear 
 
 
 pop di 
 pop cx
 pop ax
 pop es
 ret
 
;--------------------------------------------------------------
;--------------------------------------------------------------
scrollup:
push bp
mov bp,sp
push ax
push cx
push si
push di

push es
push ds
mov ax, 80
mul byte [bp+4]
mov si, ax
push si
shl si, 1
mov cx, 2000
sub cx, ax
mov ax, 0xb800
mov es, ax
mov ds, ax
xor di, di
cld
rep movsw
mov ax, 0x0720
pop cx
rep stosw

pop ds
pop es
pop di
pop si
pop cx
pop ax
pop bp
ret 2

;--------------------------------------------------------------
;--------------------------------------------------------------
strlen:
push bp
mov bp,sp
push es
push cx
push di
les di, [bp+4]
mov cx, 0xffff
xor al, al
repne scasb
mov ax, 0xffff
sub ax, cx
dec ax
pop di
pop cx
pop es
pop bp
ret 4

;--------------------------------------------------------------
;--------------------------------------------------------------
printstr:
push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push ds

mov ax, [bp+4]
push ax
call strlen
cmp ax, 0
jz exit
mov cx, ax
mov ax, 0xb800
mov es, ax

mov al, 80
mul byte [bp+8]
add ax, [bp+10]
shl ax, 1
mov di,ax

mov si, [bp+4]
mov ah, [bp+6]
cld
nextchar:
lodsb
stosw
loop nextchar
exit:
pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 8

;--------------------------------------------------------------
;--------------------------------------------------------------
delayFewSec:

push cx
mov dx, 0
loop2:

mov cx,0
loopp:
inc cx
cmp cx, 0x0F00
jne loopp

inc dx
cmp dx, 9
jne loop2

pop cx
ret

;--------------------------------------------------------------
;--------------------------------------------------------------
movestars:
 push bp 
 mov bp,sp 
 push ax 
 push cx 
 push si 
 push di 
 push es 
 push ds 
 
 mov si, 0 ; last location on the screen 
 mov cx, 80 ; number of screen locations 

 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov ds, ax ; point ds to video base 
 
 mov di, 3680 ; point di to lower right column 
 cld ; set auto increment mode 
 rep movsw ; scroll

 
 pop ds 
 pop es 
 pop di 
 pop si 
 pop cx 
 pop ax 
 pop bp 
 ret 2 

;--------------------------------------------------------------
;--------------------------------------------------------------
bg:
push es
push ax
push di
mov ax, 0xb800
mov es, ax

mov di,0
blue:
mov word [es:di], 0x1BB0
add di, 2
cmp di, 4000
jne blue

mov di,3040
red:
mov word [es:di], 0x4CB0
add di, 2
cmp di, 4000
jne red

mov di,3680
brown:
mov word [es:di], 0x06B2
add di, 2
cmp di, 4000
jne brown

pop di
pop ax
pop es
ret

;--------------------------------------------------------------
;--------------------------------------------------------------
greyclouds:
push es
push ax
push di
mov ax, 0xb800
mov es, ax


mov di,190
c2:
mov word [es:di], 0x7FB2
add di, 2
cmp di, 200
jne c2

mov di,360
c3:
mov word [es:di], 0x7FB2
add di, 2
cmp di, 390
jne c3

mov di, 500
c4:
mov word [es:di], 0x7FB2 
add di, 2
cmp di, 530
jne c4

mov di,650
c5:
mov word [es:di], 0x7FB2 
add di, 2
cmp di, 700
jne c5

mov di, 240
c6:
mov word [es:di], 0x7FB2 
add di, 2
cmp di, 250
jne c6

mov di, 430
c7:
mov word [es:di], 0x7FB2  
add di, 2
cmp di, 440
jne c7

mov di, 600
c8:
mov word [es:di], 0x7FB2 
add di, 2
cmp di, 630
jne c8

mov di, 740
c9:
mov word [es:di], 0x7FB2 
add di, 2
cmp di, 770
jne c9

mov di, 890
c10:
mov word [es:di], 0x7FB2 
add di, 2
cmp di, 940
jne c10

pop di
pop ax
pop es
ret

;--------------------------------------------------------------
;--------------------------------------------------------------
bucket:	
push es
push ax 
push bx
push cx
push di
mov bx,22 ;y pos
mov ax,0xb800
mov es,ax
mov ax,0
mov al,80
mul bx
add ax,[varx] ;x pos
shl ax,1

mov di,ax
mov cx, 2
		
l1:		
mov word[es:di], 0x08B2
add di, 10
mov word[es:di], 0x08B2
add di, 160
sub di,10
dec cx
cmp cx, 1
jne l1
		
mov bx,6 
loop1:
mov word[es:di], 0x08B2
add di,2
dec bx
jnz loop1

pop di
pop cx
pop bx
pop ax
pop es
		
ret

;--------------------------------------------------------------
;--------------------------------------------------------------
bomb:
push bp
mov bp,sp	
push es
push ax 
push bx
push cx
push di

mov bx,[bp+6];y pos
mov ax,0xb800
mov es,ax
mov ax,0
mov al,80
mul bx
add ax,[bp+4] ;x pos
shl ax,1

mov di,ax
mov cx,9

mov si, TNT   ; point si to string
mov ah, 0x0F ; load attribute in ah 
ll2:
mov al, [si]
mov word[es:di],ax
add di,2
add si,1
dec cx
cmp cx,6
jne ll2


sub di,6
add di,160


ll1:
mov word[es:di],0x40B0
add di,2
dec cx
cmp cx,3
jne ll1


pop di
pop cx
pop bx
pop ax
pop es
pop bp
ret 4

;--------------------------------------------------------------
;--------------------------------------------------------------
gem1:
push bp
mov bp,sp	
push es
push ax 
push bx
push cx
push di

mov bx,[bp+6];y pos
mov ax,0xb800
mov es,ax
mov ax,0
mov al,80
mul bx
add ax,[bp+4] ;x pos
shl ax,1
mov di,ax

mov cx,3
loopy:
mov word[es:di],0x3380
add di,2
dec cx
jnz loopy

add di,154
mov cx,3
loopx:
mov word[es:di],0x3380
add di,2
dec cx
jnz loopx



pop di
pop cx
pop bx
pop ax
pop es
pop bp

ret 4

;--------------------------------------------------------------
;--------------------------------------------------------------
gem3:
push bp
mov bp,sp	
push es
push ax 
push bx
push cx
push di

mov bx,[bp+6];y pos
mov ax,0xb800
mov es,ax
mov ax,0
mov al,80
mul bx
add ax,[bp+4] ;x pos
shl ax,1
mov di,ax

mov cx,3
loopy2:
mov word[es:di],0x5582
add di,2
dec cx
jnz loopy2

add di,154
mov cx,3
loopx2:
mov word[es:di],0x5582
add di,2
dec cx
jnz loopx2

pop di
pop cx
pop bx
pop ax
pop es
pop bp

ret 4

;--------------------------------------------------------------
;--------------------------------------------------------------
gem2:
push bp
mov bp,sp	
push es
push ax 
push bx
push cx
push di

mov bx,[bp+6];y pos
mov ax,0xb800
mov es,ax
mov ax,0
mov al,80
mul bx
add ax,[bp+4] ;x pos
shl ax,1
mov di,ax

mov cx,3
loopy1:
mov word[es:di],0x2281
add di,2
dec cx
jnz loopy1

add di,154
mov cx,3
loopx1:
mov word[es:di],0x2281
add di,2
dec cx
jnz loopx1


pop di
pop cx
pop bx
pop ax
pop es
pop bp

ret 4

;-----------------------------------------------------
; this function generates a random number between the range 0 to bp+6 and returns it which is accessed after IP is return
; bp + 6 = space for output variable
; bp + 4 = range for random number (0 to bp + 4)
;-----------------------------------------------------
get_random_number:
push bp
mov bp, sp

push ax
push bx
push cx
push dx

mov ax, word[second]
mov bx, 25174
mul bx
add ax, 13850
mov dx, 0
mov cx, [bp+4]
shr ax, 5
add cx, 1
div cx
mov [bp+6], dx

pop dx
pop cx
pop bx
pop ax

pop bp
ret 2

;--------------------------------------------------------------
;--------------------------------------------------------------
check_for_collisions:
push ax
push bx
push cx
push dx
;...........................
;collision check with gem1
mov ax, [yposgem1]
add ax,2;as last ypos in 3x3 is checked only 
cmp ax,22
jne next
;if ypos are same then check for xpos

mov bx,[varx]; bucket position
mov dx, 0
g11:
mov cx, 0
mov ax,[xposgem1]
g1:
cmp ax,bx
je gem1score
inc ax ;all three locations of gem are compared with bx

inc cx
cmp cx, 3
jne g1

inc bx ;to increment the xloc of bucket and check it with all three xpos of gem1
inc dx
cmp dx, 3
jne g11
;.........................

jmp next
gem1score:
add word[score], 5

;_________________________
next:
;collision check with gem2
mov ax, [yposgem2]
add ax,2;as last ypos in 3x3 is checked only 
cmp ax,22
jne nextgem
;if ypos are same then check for xpos

mov bx,[varx]; bucket position
mov dx, 0
g22:
mov cx, 0
mov ax,[xposgem2]
g2:
cmp ax,bx
je gem2score
inc ax ;all three locations of gem are compared with bx

inc cx
cmp cx, 3
jne g2

inc bx ;to increment the xloc of bucket and check it with all three xpos of gem1
inc dx
cmp dx, 3
jne g22
;.........................

jmp nextgem
gem2score:
add word[score], 10


;_________________________
nextgem:
;collision check with gem3
mov ax, [yposgem3]
add ax,2;as last ypos in 3x3 is checked only 
cmp ax,22
jne nextbomb
;if ypos are same then check for xpos

mov bx,[varx]; bucket position
mov dx, 0
g33:
mov cx, 0
mov ax,[xposgem3]
g3:
cmp ax,bx
je gem3score
inc ax ;all three locations of gem are compared with bx

inc cx
cmp cx, 3
jne g3

inc bx ;to increment the xloc of bucket and check it with all three xpos of gem1
inc dx
cmp dx, 3
jne g33
;.........................

jmp nextbomb
gem3score:
add word[score], 15

;_________________________
nextbomb:

mov ax, [ytnt]
add ax,2;as last ypos in 3x3 is checked only 
cmp ax,22
jne endcheck
;if ypos are same then check for xpos

mov bx,[varx]; bucket position
mov dx, 0
b11:
mov cx, 0
mov ax,[xtnt]
b1:
cmp ax,bx
je bombb
inc ax ;all three locations of gem are compared with bx

inc cx
cmp cx, 3
jne b1

inc bx ;to increment the xloc of bucket and check it with all three xpos of gem1
inc dx
cmp dx, 3
jne b11
;.........................
;if it is equal to bombb then 
jmp endcheck
bombb:
add word[collisionCheck], 1

endcheck:
pop dx
pop cx
pop bx
pop ax
ret
;--------------------------------------------------------------
printgems:

;first it generates a random number, then three gems are printed at 3 random locations,
; after this loop starts, if the ypos of gem becomes 22 then makes count 0 to gen new number
 
 cmp word[yposgem1],0
 jne here1
 ;getrandomnumberinx
 push word[xposgem1]
 push 72
 call get_random_number
 pop word[xposgem1]


 here1: 

 cmp word[yposgem2],0
 jne here2
 ;getrandomnumberinx
 call delay
 push word[xposgem2]
 push 72
 call get_random_number
 pop word[xposgem2]
 
 here2:
 
 cmp word[yposgem3],0
 jne here3
 call delay
 ;getrandomnumberinx
 push word[xposgem3]
 push 72
 call get_random_number
 pop word[xposgem3]
 
 here3:

 cmp word[ytnt],0
 jne here4
 ;getrandomnumberinx
 call delay

 push word[xtnt]
 push 72
 call get_random_number
 pop word[xtnt]
 
 here4:

;printing gems
mov ax,word[yposgem1]
push ax
mov ax,word[xposgem1]
push ax
call gem1

mov ax,word[yposgem2]
push ax
mov ax,word[xposgem2]
push ax
call gem2

mov ax, word[yposgem1]
push ax
mov ax,word[xposgem3]
push ax
call gem3

;printing tnt
mov ax, word[ytnt]
push ax
mov ax,word[xtnt]
push ax
call bomb
 
 inc word[yposgem1]
 inc word[yposgem2]
 inc word[yposgem3]
 inc word[ytnt]

 ;calling subroutine for collisions here
 call check_for_collisions
 
 cmp word[yposgem1],22
 jl gem2h
 mov word[yposgem1],0

gem2h: 
 cmp word[yposgem2],22
 jl gem3h
 mov word[yposgem2],0

 
gem3h:
 cmp word[yposgem3],22
 jl gemh
 mov word[yposgem3],0
gemh:

 cmp word[ytnt],22
 jl tnth
 mov word[ytnt],0
tnth:

ret

;----------------------------------printscore---------------------------------------
printscore:
 push bp 
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx 
 push dx 
 push di 
 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 
 mov ax, [score] ; load score in ax 
 mov bx, 10 ; use base 10 for division 
 mov cx, 0 ; initialize count of digits 
 
nextdigit: mov dx, 0 ; zero upper half of dividend 
 div bx ; divide by 10 
 add dl, 0x30 ; convert digit into ascii value 
 push dx ; save ascii value on stack 
 inc cx ; increment count of values 
 cmp ax, 0 ; is the quotient zero 
 jnz nextdigit ; if no divide it again 
 
 ;calculate di 
mov al, 80
mul byte [bp+4] ;y
add ax, [bp+6] ;x
shl ax, 1
mov di,ax

nextpos: 
 pop dx ; remove a digit from the stack 
 mov dh, 0x07 ; use normal attribute 
 mov [es:di], dx ; print char on screen 
 add di, 2 ; move to next screen location 
 loop nextpos ; repeat for all digits on stack
 
 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax 
 pop es 
 pop bp 
 ret 2

;---------------------------------- [MAIN] ----------------------------

start:
 call clrscr
 call printStars
 mov cx, 0
 
here:
 call movestars
 mov ax, 1
 push ax ;  push number of lines to scroll 
 call scrollup ; call scroll subroutine 
 call delayFewSec
 inc cx
 cmp cx, 6
 jne here

 call printStart
 call printWords
  
 mov ah, 0 ; service 0 – get keystroke 
 int 0x16 ; call BIOS keyboard service 
;--------------------------------------------------------------------------------
 xor ax, ax 
 mov es, ax ; point es to IVT base 
 mov ax, [es:9*4] 
 mov [oldisr], ax ; save offset of old routine 
 mov ax, [es:9*4+2] 
 mov [oldisr+2], ax ; save segment of old routine 
 
 cli ; disable interrupts 
 mov word [es:9*4], kbisr ; store offset at n*4 
 mov [es:9*4+2], cs ; store segment at n*4+2 
 sti ; enable interrupts 
 
 xor ax, ax
 mov es, ax ; point es to IVT base

 cli ; disable interrupts
 mov word [es:8*4], timer; store offset at n*4
 mov [es:8*4+2], cs ; store segment at n*4+2
 sti ; enable interrupts

 mov dx, start ; end of resident portion
 add dx, 10 ; round up to next para
 mov cl, 4
 shr dx, cl ; number of paras

 mov ax, 0x3100 ; terminate and stay resident
;....................................................................................
gameloop:

 call bg
 call greyclouds
 call bucket
 call printgems ;prints gems and calls check_for_collisions

 mov ax,140
 push ax
 push word [cs:second]
 call printnum ; print tick count

 mov ax, 0
 push ax ;ypos
 push ax ;xpos
 call printscore

 call delayFewSec
 call delayFewSec  
 
 cmp word[cs:second],120 ; game ends after 2 mins (120 seconds)
 jge endgameloop

 cmp word[esccheck], 1 ;checks for esc key
 je endgameloop
 
 cmp word[collisionCheck], 1
 jne gameloop
 ;if there was a collision 
 
;.................................................
endgameloop:
 
 mov ax, [oldisr] ; read old offset in ax 
 mov bx, [oldisr+2] ; read old segment in bx 
 
 cli ; disable interrupts 
 mov [es:9*4], ax ; restore old offset from ax 
 mov [es:9*4+2], bx ; restore old segment from bx 
 sti ; enable interrupts 
 
;--------------------------------------------------

call delayFewSec
call clrscr

mov ax,34 ; y pos
push ax
mov ax,10 ; x pos
push ax
mov ax, 2
push ax
mov ax, message
push ax
call printstr
call delay1
mov ax,1
push ax
call scrollup

mov ax,34
push ax
mov ax,10

push ax
mov ax, 2
push ax
mov ax, message2
push ax
call printstr
mov ax,42
push ax
mov ax,10
push ax
call printscore



mov ax,34
push ax
mov ax,11
push ax
mov ax, 2
push ax
mov ax, message3
push ax
call printstr


mov ax,1844
push ax
push word [cs:second]
call printnum ; print tick count

mov ax, 0x4c00
int 0x21