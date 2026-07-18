    .section .data
msg:
    .ascii "Hello, shork!\n"
len = . - msg

    .section .text
    .globl _start

_start:
    # write(1, msg, len)
    movl $4, %eax
    movl $1, %ebx
    movl $msg, %ecx
    movl $len, %edx
    int $0x80

    # exit(0)
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
