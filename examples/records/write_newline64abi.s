#64bit no abi

#writes new line to stdout

#input file_id (in %rdi)

.include "linux64.s"

.globl write_newline
    .type write_newline, @function
.section .data
newline:
    .ascii "\n"
.section .text
write_newline:
    movq  $SYS_WRITE, %rax
    #File id already in rdi: movq  %rdi, %rdi  
    movq  $newline, %rsi
    movq  $1, %rdx
    syscall
    
    ret
