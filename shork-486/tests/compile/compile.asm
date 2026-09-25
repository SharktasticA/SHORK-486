section .data
msg: db "Hello, shork!", 10
len: equ $ - msg

section .text
    global _start

_start:
    ; write(1, msg, len)
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    ; exit(0)
    mov eax, 1
    xor ebx, ebx
    int 0x80
