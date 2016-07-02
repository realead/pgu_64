#64bit no abi
.include "record_def.s"
.include "linux64.s"
#PURPOSE:   This function reads a record from the file
#           descriptor
#
#INPUT:     The file descriptor and a buffer
#
#OUTPUT:    This function writes the data to the buffer
#           and returns a status code.
#
#STACK LOCAL VARIABLES
    .equ ST_READ_BUFFER, 16
    .equ ST_FILEDES, 24
.section .text
    .globl read_record
    .type read_record, @function
read_record:
    pushq %rbp
    movq  %rsp, %rbp
    
    movq  $SYS_READ, %rax            #read
    movq  ST_FILEDES(%rbp), %rdi     #from this file
    movq  ST_READ_BUFFER(%rbp), %rsi #into this buffer
    movq  $RECORD_SIZE, %rdx         #up to so many bytes
    syscall
    
    #NOTE - %rax has the return value, which we will
    #       give back to our calling program
    
    movq  %rbp, %rsp
    popq  %rbp
    ret
    
    
