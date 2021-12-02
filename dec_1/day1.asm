global _start

section .data
	; Align to the nearest 2 byte boundary, must be a power of two
	align 2
	; String, which is just a collection of bytes, 0xA is newline
	str: db 'Hello, world!',0xA
	strLen: equ $-str

section .bss
	string_buffer: resb 16
	buffer_end: equ $-string_buffer

	input_buffer: resb 20000
	input_end: equ $-input_buffer

	window_buffer: resb 12

section .text

_start:	call main

main:	
	call read_stdin
	call solve
	call part2
	call exit

solve:	mov rax, input_buffer
	mov edx, 0
	push rdx
	call read_number
	pop rdx
solve_1:
	mov ecx, ebx
	push rdx
	call read_number
	pop rdx
	cmp ecx, ebx
	jge solve_2
	add edx, 1
solve_2:
	cmp ecx, 0
	je solve_3
	jmp solve_1
solve_3:
	mov eax, edx
	call print_num
	ret

part2:	mov rax, input_buffer
	mov edx, 0
	push rdx
	call read_number
	mov [window_buffer], ebx
	call read_number
	mov [window_buffer + 4], ebx
	call read_number
	mov [window_buffer + 8], ebx
	pop rdx
	call sum_window_buffer
part2_1:	
	mov ecx, ebx
	push rdx

	mov edx, [window_buffer + 4]
	mov [window_buffer], edx
	
	mov edx, [window_buffer + 8] 
	mov [window_buffer + 4], edx
	
	call read_number
	mov [window_buffer + 8], ebx
	
	pop rdx
	cmp ebx, 0
	je part2_2
	call sum_window_buffer
	cmp ecx, ebx
	jge part2_1
	add edx, 1
	jmp part2_1
part2_2:
	mov eax, edx
	call print_num
	ret

; returns window_buffer's sum to ebx
sum_window_buffer:
	mov ebx, [window_buffer]
	add ebx, [window_buffer + 4]
	add ebx, [window_buffer + 8]
	ret

; reads the entire file from stdin into the input buffer
read_stdin:
	mov eax, 0
	mov edi, 0
	mov rsi, input_buffer
	mov edx, 20000
	syscall
	ret

; rax contains the buffer pointer
; rax returns the pointer to the next number
; ebx returns the read number
read_number:
	mov ebx, 0
read_number_1:
	mov dl, 0x0A ; '\n'
	mov dh, [rax]
	cmp dh, dl
	je read_number_2

	imul ebx, 10
	movsx edx, dh
	add ebx, edx
	sub ebx, 0x30 ; '0'
	add rax, 1
	jmp read_number_1
read_number_2:
	add rax, 1
	ret

; eax contains an unsigned number to print
print_num:
	push rax
	push rax
	call clear_buffer
	mov ecx, buffer_end
	add ecx, string_buffer
	sub ecx, 1
	mov edx, 0
	pop rax
print_num_1:
	cmp eax, 0
	je print_num_2

	; eax / 10 -> eax
	; eax % 10 -> ed
	mov eax, eax
	mov edx, 0
	mov ebx, 10
	div ebx

	add edx, 0x30 ; '0'
	sub ecx, 1
	mov [ecx], dl
	jmp print_num_1
print_num_2:
	; &buffer_end - length -> edx
	mov edx, buffer_end
	add edx, string_buffer
	sub edx, ecx
	call print
	pop rax
	ret	

clear_buffer:
	mov eax, 0x20202020
	mov ebx, string_buffer
	mov [ebx], eax
	mov [ebx + 4], eax
	mov [ebx + 8], eax
	mov eax, 0x0A202020 ; Little endian, new line comes first
	mov [ebx + 12], eax
	ret

; edx contains string length
; ecx contains string pointer
print:	mov	ebx, 1          ; Arg one: file descriptor, in this case stdout
	mov	eax, 4          ; Syscall number, in this case the write(2) syscall: 
	int	0x80            ; Interrupt 0x80        
	ret


exit:	mov	ebx, 0          ; Arg one: the status
	mov	eax, 1          ; Syscall number:
	int	0x80
	ret

