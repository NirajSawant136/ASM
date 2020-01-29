%macro print 2
	mov rax , 1
	mov rdi , 2
	mov rsi , %1
	mov rdx , %2
	syscall
%endmacro

%macro exit 0
	mov rax , 60
	mov rdi , 0
	syscall
%endmacro

%macro read 2
	mov rax , 0
	mov rdi , 0
	mov rsi , %1
	mov rdx , %2
	syscall
%endmacro

section .data
	ano db 10,"Assignment 3", 10 , 10
	ano_len equ $-ano

	choices db 10,"1. HEX to BCD"
			db 10,"2. BCD to HEX"
			db 10,"3. exit:"
	choices_len equ $-choices

	choice db 10 , 10, "Enter Choice: "
	choice_len equ $-choice

	Invalid db 10,"Invalid Choice!"
	Invalid_len equ $-Invalid

	hb db 10,"Enter 4-digit HEX number -> "
	hb_len equ $-hb

	bh1 db 10,"Enter 4-digit BCD number -> "
	bh1_len equ $-bh1

	err db 10,"Invalid Number!",10
	err_len equ $-err

	eb db 10,"Corresponding BCD Number -> "
	eb_len equ $-eb

	eh db 10,"Corresponding HEX Number -> "
	eh_len equ $-eh

section .bss
	char_ans resb 4
	buf resb 2

section .text:
global _start
_start:
	print ano , ano_len
	Menu:
		print choices , choices_len
		print choice , choice_len
		read buf  , 2
		mov al , [buf]
	c1:
		cmp al , '1'
		jne c2
		call HEX_BCD
		jmp Menu
	c2:
		cmp al , '2'
		jne c3
		call BCD_HEX
		jmp Menu
	c3:
		cmp al , '3'
		jne invalid
		exit
	invalid:
		print Invalid , Invalid_len
	exit

display:
	mov rbx, 16
	mov rcx, 4
	mov rsi, char_ans + 3
	
	cnt:
		mov rdx, 0
		div rbx
		cmp dl, 09h
		jbe add30
		add dl, 07h
		
	add30:
		add dl, 30h
		mov [rsi], dl
		dec rsi
		dec rcx
		jnz cnt
		print char_ans, 4
	
	ret

HEX_BCD:
	print hb , hb_len
	call accept
	mov ax , bx
	mov bx , 10
	xor bp , bp
	back:
		xor dx , dx
		div bx 
		push dx
		inc bp
		cmp ax , 0
		jnz back
		print eb , eb_len
	back1:
		pop dx
		add dl , 30h
		mov [char_ans] , dl
		print char_ans , 1
		dec bp 
		jnz back1
	ret

BCD_HEX:
	print bh1 , bh1_len
	read buf , 6
	mov rsi , buf 
	xor ax , ax
	mov rbp , 5
	mov rbx , 10
	next:
		xor cx , cx
		mul bx
		mov cl , [rsi]
		sub cl , 30h
		add ax , cx
		inc rsi
		dec rbp
		jnz next
		mov [char_ans] , ax
		print eh , eh_len
		mov ax , [char_ans]
		call display
	ret

accept:
	read buf , 5                                                     
	mov rcx , 4
	mov rsi , buf
	xor bx , bx

	next_byte:
		shl bx , 4
		mov al , [rsi]
		cmp al , '0'
		jb error
		cmp al , '9'
		jbe sub30
		cmp al , 'A'
		jb error
		cmp al , 'F'
		jbe sub37
		cmp al , 'a'
		jb error
		cmp al , 'f'
		jbe sub57

	error:
		print err , err_len
		exit

	sub57:
		sub al , 20h
	sub37:
		sub al , 07h
	sub30:
		sub al , 30h

	add bx , ax
	inc rsi
	dec rcx
	jnz next_byte
	ret