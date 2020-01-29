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

section .data:
	nline db 10,10
	nline_len equ $-nline
	
	ano db 10,"Assignment 1",10
	    db "positive/negative no from 64 bit array", 10
	ano_len equ $-ano
	
	array dq -11111111H , 22222222H , -33333333H , 444444444H 
	n equ 4
	
	pmsg db 10,"Total number of positive no.s are : "
	pmsg_len equ $-pmsg
	
	nmsg db 10,"Total number of negative no.s are : "
	nmsg_len equ $-nmsg
	
section .bss
	P_count resq 1
	n_count resq 1
	char_ans resb 16
	
section .text:
global _start
_start:
	print ano , ano_len
	mov rsi , array
	mov rcx , n
	mov rbx , 0
	mov rdx , 0
	
Next_num:
	mov rax , [rsi]
	rol rax , 1
	jc negative

positive:
	inc rbx
	jmp next

negative:
	inc rdx
	
next:
	add rsi , 8
	dec rcx
	jnz Next_num
	mov [P_count],rbx
	mov [n_count],rdx
	
	print pmsg , pmsg_len
	mov rax , [P_count]
	call display
	
	print nmsg , nmsg_len
	mov rax,[n_count]
	call display
	
	print nline , nline_len
	exit
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
