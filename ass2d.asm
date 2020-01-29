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

section .data
	
	nline db 10
	nline_len equ $-nline
	
	space db " "
	
	ano db 10,"Assignment 2D", 10
	    db 10,"Before Transfer:", 10
	ano_len equ $-ano
	   
	aq db 10,"Source Block -> "
	aq_len equ $-aq
	
	aa db 10,"Destination Block -> "
	aa_len equ $-aa
	
	
	ap db 10,"After Transfer", 10
	ap_len equ $-ap
	
	sblock db 11H , 22H , 33H , 44H , 55H
	n equ 5
	
	dblock times 5 db 0 
	m equ 4

section .bss
	char_ans resb 2
	
section .text:
global _start
_start:
	print ano , ano_len
	print aq , aq_len
	
	mov rsi , sblock
	call display_block
	
	print aa , aa_len
	
	mov rsi , dblock
	call display_block
	
	print nline , nline_len
	print ap , ap_len
	
	call block_transfer
	
	print aq , aq_len
	mov rsi , sblock
	call display_block
	
	print aa , aa_len
	mov rsi , dblock - 2
	call display_block
	exit
	
	
block_transfer:
	mov rsi , sblock + 4
	mov rdi , dblock + 2
	mov rcx , 5
	back:
		mov al , [rsi]
		mov [rdi] , al
		dec rsi
		dec rdi
		dec rcx
		jnz back                
	ret
	
	
display_block:
	mov rbp , 5
	Next_Num:
		mov al , [rsi]
		push rsi
		call display
		print space , 1
		pop rsi
		inc rsi
		dec rbp
		jnz Next_Num
	ret


		
display:
	mov rbx, 16
	mov rcx, 2
	mov rsi, char_ans +1
	
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
		print char_ans, 2
	
	ret
