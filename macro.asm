%macro print 2
	mov rax , 1
	mov rdi , 1
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
	msg db 10,"First Message",10
	msg_len equ $-msg
	msg1 db 10,"Second Message",10
	msg1_len equ $-msg1
	
section .text:
global _start
_start:
	print msg , msg_len
	print msg1 , msg1_len
	exit
