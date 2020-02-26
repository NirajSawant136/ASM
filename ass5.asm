%include "file.asm"

section .data

	msg0 db 10,"ASSIGNMENT 5",10
	msg0_len equ $- msg0

	msg1 db 10,"1.No of Blank Spaces",10,"2.Occurance of a letter",10,"3.No of Lines",10,"4.Exit",10,"=>=>=>",10
	msg1_len equ $- msg1

	invalid_msg db 10,"Invalid Option Entered",10
	invalid_msg_len equ $- invalid_msg

	msg2 db 10,"No of blank Spaces are : ",10
	msg2_len equ $- msg2

	msg4 db 10,"No of new lines are : ",10
	msg4_len equ $- msg4

	msg5 db 10,"No of searched character are : ",10
	msg5_len equ $- msg5

	msg3 db 10,"Enter the letter : ",10
	msg3_len equ $- msg3

	e_msg db 10,"Invalid input",10
	e_msg_len equ $- e_msg

	answer_msg db 10,"ANS = "
	answer_msg_len equ $- answer_msg

	fmsg db 10,"Enter File name -> "
	fmsg_len equ $- fmsg

	cmsg db 10,"Enter character to be searched ->   "
	cmsg_len equ $- cmsg


	nline db 10,10
	nline_len equ $-nline


section .bss
	char resb 2
	char_ans resb 16
	buf resb 4096
	buf_len equ $-buf
	filename resb 50
	ncount resq 1
	scount resq 1
	ccount resq 1
	filehandler resq 1
	abuff resq 1



section .text
	global _start
		_start:
			print msg0 , msg0_len   ; ASS5
			print fmsg , fmsg_len
			read filename , 50
			dec rax

			mov byte[filename + rax] , 0
			print cmsg , cmsg_len
			read char , 2
			fopen filename
			cmp rax , -1H
			jle error
			mov [filehandler] , rax
			fread [filehandler] , buf,buf_len
			mov [abuff] , rax
			call far_procedure
			exit

		error:
			print e_msg,e_msg_len
			exit


far_procedure:
	xor rax , rax
	xor rbx , rbx
	xor rcx , rcx
	xor rsi , rsi
	mov bl , [char]
	mov rsi , buf
	mov rcx , [abuff]
	
	again:
		mov al , [rsi]

		case_s:
			cmp al , 20h
			jne case_n
			inc qword[scount]
			jmp next

		case_n:
			cmp al , 0Ah
			jne case_c
			inc qword[ncount]
			jmp next

		case_c:
			cmp al , bl
			jne next
			inc qword[ccount]

		next:
			inc rsi
			dec rcx
			jnz again

	print msg2 , msg2_len
	mov rax , [scount]
	call Display

	print msg4 , msg4_len
	mov rax , [ncount]
	call Display

	print msg5 , msg5_len
	mov rax , [ccount]
	call Display

	print nline , nline_len
	fclose [filehandler]
	ret


Blank:
	print msg2,msg2_len
	ret

Occurance:
	print msg3,msg3_len
	ret
Lines:
	print answer_msg,answer_msg_len
	ret

Display_menu:
	mov rax ,1
    mov rdi, 1
    mov rsi ,msg1
    mov rdx ,msg1_len
    syscall
	ret


Display:
	mov rbx , 16
	mov rcx , 4
	mov rsi , char_ans + 3

	cnt:
		mov rdx , 0
		div rbx
		cmp dl , 09h
		jbe add30
		add dl , 07h

	add30:
		add dl , 30h
		mov [rsi] , dl
		dec rsi
		dec rcx
		jnz cnt
		print char_ans , 4
 	ret