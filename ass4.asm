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

section .data:
	ano db 10,"Assignment 4", 10 , 10
	ano_len equ $-ano

	choices db 10,10,"1. Multiplication by successive addition"
			db 10,"2. Multiplication by shift-add method"
			db 10,"3. exit:"
	choices_len equ $-choices

	choice db 10 , 10, "Enter Choice: "
	choice_len equ $-choice

	a1 db 10, "Enter no1 : "
	a1_len equ $-choice

	b1 db 10, "Enter no2 : "
	b1_len equ $-choice

	ans db 10 , 10, "Answer : "
	ans_len equ $-choice

	err db 10,"Error"
	err_len equ $-err

	Invalid db 10,"Invalid Choice!"
	Invalid_len equ $-Invalid

section .bss
	char_ans resb 4
	buf resb 3
	n1 resw 1
	n2 resw 1
	ansh resw 1
	ansl resw 1


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
		call succADD
		jmp Menu
	c2:
		cmp al , '2'
		jne c3
		call shiftADD
		jmp Menu
	c3:
		cmp al , '3'
		jne invalid
		exit
	invalid:
		print Invalid , Invalid_len
	exit

succADD:
	mov word[ansh] , 00
	mov word[ansl] , 00
	print a1 , a1_len
	call accept
	mov [n1] , bx
	print b1 , b1_len
	call accept
	mov [n2] , bx
	mov ax , [n1]
	mov cx , [n2]
	cmp cx , 0
	je final
	back:
		add [ansl] , ax
		jnc next
		inc word[ansh]
	next:
		dec cx
		jnz back
	final:
		print ans , ans_len
		mov ax , [ansh]
		call display
		mov ax , [ansl]
		call display
	ret 

shiftADD:

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

accept:
	read buf , 3                                                     
	mov rcx , 2
	mov rsi , buf
	xor bx , bx

	next_byte:
		shl bx , 2
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