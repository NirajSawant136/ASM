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

	Invalid db 10,"Invalid Choice!"
	Invalid_len equ $-Invalid

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