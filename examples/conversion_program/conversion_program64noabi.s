.include "linux64.h"
.section .data
#This is where it will be stored
tmp_buffer:
    .ascii "\0\0\0\0\0\0\0\0\0\0\0"
    
.section .text
    .globl _start
_start:
    movq %rsp, %rbp
    
    pushq $tmp_buffer #Storage for the result
    pushq $824 #Number to convert
    call integer2string
    addq $16, %rsp
    
    #Get the character count for our system call
    pushq $tmp_buffer
    call count_chars
    addq $8, %rsp
    
    #The count goes in %edx for SYS_WRITE
    movq %rax, %rdx
    #Make the system call
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $tmp_buffer, %rsi
    syscall
    
    #Write a carriage return
    pushq $STDOUT
    call write_newline
    
    #Exit
    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall


