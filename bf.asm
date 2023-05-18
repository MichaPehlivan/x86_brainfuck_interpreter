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

    ; initialize tape to 0's
    mov r10, tape
    mov r11, 30000
initstart:
    cmp r11, 0
    je initend
    mov byte [r10], 0
    inc r10
    dec r11
initend:

    mov r9, bf_code ; current command pointer
    mov r10, tape ; tape pointer

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
    inc r10 ; move pointer right
    inc r9
    jmp loopstart
left:
    dec r10 ; move pointer left
    inc r9
    jmp loopstart
plus:
    inc byte [r10] ; add 1 to value at pointer
    inc r9
    jmp loopstart
minus:
    dec byte [r10] ; subtract 1 from value at pointer
    inc r9
    jmp loopstart
output:
    ; output current value
    mov rax, 1
    mov rdi, 1
    mov rsi, r10
    mov rdx, 1
    syscall

    inc r9
    jmp loopstart
input:
    ; get input
    mov rax, 0
    mov rdi, 1
    mov rsi, r10
    mov rdx, 1
    syscall

    inc r9
    jmp loopstart
bracket_open:
    cmp byte [r10], 0
    je skip_loop
    push r9

    inc r9
    jmp loopstart
skip_loop:
    cmp byte [r9], BRACKET_OPEN
    je open_found
    cmp byte [r9], BRACKET_CLOSE
    je close_found
    inc r9
    cmp r13, r14
    je loopstart
open_found:
    inc r13 ; open bracket counter
    inc r9
    jmp skip_loop
close_found:
    inc r14 ; close bracket counter
    inc r9
    jmp skip_loop
bracket_close:
    cmp byte [r10], 0
    jne jump_back
    pop rax

    inc r9
    jmp loopstart
jump_back:
    pop r9
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
    MAX_CODE_LEN equ 10000

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
    newline db 10

section .bss
    bf_code resb 10000
    tape resb 30000
