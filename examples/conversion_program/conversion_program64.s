.include "linux64.h"
.section .data
#This is where it will be stored
tmp_buffer:
    .ascii "\0\0\0\0\0\0\0\0\0\0\0"
    
.section .text
    .globl _start
_start:
    movq %rsp, %rbp
    
    
    movq $824,  %rdi #Number to convert
    movq $tmp_buffer, %rsi #Storage for the result
    call integer2string
    
    #Get the character count for our system call
    movq $tmp_buffer, %rdi
    call count_chars
    
    
    #The count goes in %edx for SYS_WRITE
    movq %rax, %rdx
    #Make the system call
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $tmp_buffer, %rsi
    syscall
    
    #Write a carriage return
    movq $STDOUT, %rdi
    call write_newline
    
    #Exit
    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall


