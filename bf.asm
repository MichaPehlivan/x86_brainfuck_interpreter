section .text
    global _start
_start:
    ; print input request
    mov rax, 1
    mov rdi, 1
    mov rsi, input_msg
    mov rdx, INPUT_MSG_LEN
    syscall

    ; get input code
    mov rax, 0
    mov rdi, 1
    mov rsi, bf_code
    mov rdx, MAX_CODE_LEN
    syscall

    mov r9, bf_code ; current command pointer

    ; brainfuck loop:
loopstart:
    mov r8b, byte [r9] ; current command
    cmp r8b, RIGHT
    je right
    cmp r8b, LEFT
    je left
    cmp r8b, PLUS
    je plus
    cmp r8b, MINUS
    je minus
    cmp r8b, OUTPUT
    je output
    cmp r8b, INPUT
    je input
    cmp r8b, BRACKET_OPEN
    je bracket_open
    cmp r8b, BRACKET_CLOSE
    je bracket_close
    jmp loopend
right:
    inc r9
    jmp loopstart
left:
    inc r9
    jmp loopstart
plus:
    inc r9
    jmp loopstart
minus:
    inc r9
    jmp loopstart
output:
    inc r9
    jmp loopstart
input:
    inc r9
    jmp loopstart
bracket_open:
    inc r9
    jmp loopstart
bracket_close:
    inc r9
    jmp loopstart
loopend:

    ; sys exit
    mov rax, SYS_EXIT
    mov rdi, SUCCES
    syscall

section .data
    ; codes
    SYS_EXIT equ 60
    SUCCES equ 0
    INPUT_MSG_LEN equ 22
    MAX_CODE_LEN equ 1000

    ; brainfuck commands
    RIGHT equ 62
    LEFT equ 60
    PLUS equ 43
    MINUS equ 45
    OUTPUT equ 46
    INPUT equ 44
    BRACKET_OPEN equ 91
    BRACKET_CLOSE equ 93

    ; constants
    input_msg db "Input brainfuck code: "

section .bss
    bf_code resb 1000


