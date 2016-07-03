#64bit

.include "record_def.s"
.include "linux64.s"
#PURPOSE:   This function reads a record from the file
#           descriptor
#
#INPUT:     The file descriptor (rdi) and a buffer (rsi)
#
#OUTPUT:    This function writes the data to the buffer
#           and returns a status code.
#
.section .text
    .globl read_record
    .type read_record, @function
read_record:
    
    movq  $SYS_READ, %rax            #read
    #already here: movq  ST_FILEDES(%rbp), %rdi     #from this file
    #already here: movq  ST_READ_BUFFER(%rbp), %rsi #into this buffer
    movq  $RECORD_SIZE, %rdx         #up to so many bytes
    syscall
    
    #NOTE - %rax has the return value, which we will
    #       give back to our calling program

    ret
    
    
