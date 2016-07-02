.include "linux32.s"

    .equ ST_ERROR_CODE, 8
    .equ ST_ERROR_MSG, 12
    
.globl error_exit
    .type error_exit, @function
error_exit:
    pushl %ebp
    movl  %esp, %ebp
    
    #Write out error code
    movl  ST_ERROR_CODE(%ebp), %ecx
    pushl %ecx
    call  count_chars
    popl  %ecx
    movl  %eax, %edx
    movl  $STDERR, %ebx
    movl  $SYS_WRITE, %eax
    int   $LINUX_SYSCALL
    
    #Write out error message
    movl  ST_ERROR_MSG(%ebp), %ecx
    pushl %ecx
    call  count_chars
    popl  %ecx
    movl  %eax, %edx
    movl  $STDERR, %ebx
    movl  $SYS_WRITE, %eax
    int   $LINUX_SYSCALL
    
    pushl $STDERR
    call  write_newline
    
    #Exit with status 1
    movl  $SYS_EXIT, %eax
    movl  $1, %ebx
    int   $LINUX_SYSCALL
