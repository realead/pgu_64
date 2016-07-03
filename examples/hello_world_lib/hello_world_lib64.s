
#PURPOSE:  This program writes the message "hello world" and
#          exits
#
.section .data
helloworld:
    .ascii "hello world\n\0"

.section .text
    .globl _start
    
_start:
    movq $helloworld, %rdi
    call  printf
    movq $0, %rdi
    call  exit
    
    
