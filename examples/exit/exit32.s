#32bit version

#PURPOSE:  Simple program that exits and returns a
#          status code (42) back to the Linux kernel
#
#INPUT:    none
#
#OUTPUT:   returns a status code.  This can be viewed
#          by typing
#
#          echo $?
#

# %eax holds the system call number
# %ebx holds the return status


.section .text
.globl _start
_start:
    movl $1, %eax #1 -> exit
    movl $42, %ebx #return 42
    int $0x80 #run kernel
    
    
