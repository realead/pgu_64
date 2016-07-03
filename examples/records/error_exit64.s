#64bit

.include "linux64.s"

# rdi-> ST_ERROR_CODE
# rsi-> equ ST_ERROR_MSG
    
.globl error_exit
    .type error_exit, @function
error_exit:
    
    #Write out error code
    pushq %rsi
    pushq %rdi
    
    #rdi already set
    call  count_chars
    #result in rax
    
    movq  %rax, %rdx                #remember length
    movq  $SYS_WRITE, %rax          #write
    movq  $STDERR, %rdi             #to stderr
    popq  %rsi                      #error code buffer (error code was on top)
                                    #length already set
    syscall
    
    #Write out error message
    movq  (%rsp), %rdi #now second argument is on the top
    call  count_chars
    
    
    movq  %rax, %rdx                #remember length
    movq  $SYS_WRITE, %rax          #write
    movq  $STDERR, %rdi             #to stderr
    popq  %rsi                      #error message buffer (message was on the top)
                                    #length already set
    syscall
    
    movq $STDERR, %rdi
    call  write_newline
    
    #Exit with status 1
    movq  $SYS_EXIT, %rax
    movq  $1, %rdi
    syscall
    
    
    
