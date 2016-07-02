#64bit version

#changes compared to 32bit:
#
# 1. 4byte eXX registers -> 8byte rXX registers
# 2. uses movq and not movl, because registers are 8bytes long
# 3. rax value for interupt is 60 (not 1 as for 32bit)
# 4. rdi holds the return status (not ebx as for 32bit)
# 5. int $0x080  -> syscall
# 
#
# for values of syscall see http://blog.rchapman.org/post/36801038863/linux-system-call-table-for-x86-64
# or

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

# %rax holds the system call number
# %rdi holds the return status


.section .text
.globl _start
_start:   
    movq $60, %rax #60 -> exit
    movq $42, %rdi #return 42
    syscall #run kernel
    
    
