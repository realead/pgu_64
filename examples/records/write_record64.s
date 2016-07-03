.include "linux64.s"
.include "record_def.s"


#PURPOSE:   This function writes a record to
#           the given file descriptor
#
#INPUT:     The file descriptor(%rdi) and a buffer(%rsi)
#
#OUTPUT:    This function produces a status code
#
.section .text
    .globl write_record
    .type write_record, @function
write_record:
    
    movq  $SYS_WRITE, %rax             #write 
    #(already there)movq  ST_FILEDES(%rbp), %rdi       #to this file
    #(already there)movq  ST_WRITE_BUFFER(%rbp), %rsi  #this buffer
    movq  $RECORD_SIZE, %rdx           #with this length
    syscall
    #NOTE - %eax has the return value, which we will
    #       give back to our calling program

    ret
