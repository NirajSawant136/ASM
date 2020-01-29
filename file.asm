section.data:
pmsg db 10,"Hello Guys",10
pmsg_len equ $-msg

section.text:

global _start
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, pmsg
	mov rdx, pmsg_len
	syscall
	mov rax, 60
	mov rdi, 0
	syscall
