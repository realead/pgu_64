.include "linux64.s"
.include "record_def.s"

#ATENTION: This function does not follow the x86-64 abi convention as it saves the parameters on the stack

#PURPOSE:   This function writes a record to
#           the given file descriptor
#
#INPUT:     The file descriptor and a buffer
#
#OUTPUT:    This function produces a status code
#
#STACK LOCAL VARIABLES
    .equ ST_WRITE_BUFFER, 16
    .equ ST_FILEDES, 24
.section .text
    .globl write_record
    .type write_record, @function
write_record:
    pushq %rbp
    movq  %rsp, %rbp
    
    movq  $SYS_WRITE, %rax             #write 
    movq  ST_FILEDES(%rbp), %rdi       #to this file
    movq  ST_WRITE_BUFFER(%rbp), %rsi  #this buffer
    movq  $RECORD_SIZE, %rdx           #with this length
    syscall
    #NOTE - %eax has the return value, which we will
    #       give back to our calling program
    
    movq  %rbp, %rsp
    popq  %rbp
    ret
