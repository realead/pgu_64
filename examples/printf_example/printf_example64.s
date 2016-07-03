#PURPOSE:  This program is to demonstrate how to call printf
#
.section .data
#This string is called the format string.  It’s the first
#parameter, and printf uses it to find out how many parameters
#it was given, and what kind they are.
firststring:
    .ascii "Hello! %s is a %s who loves the number %d\n\0"
name:
    .ascii "Jonathan\0"
personstring:
    .ascii "person\0"
#This could also have been an .equ, but we decided to give it
#a real memory location just for kicks
numberloved:
    .long 3
.section .text
    .globl _start
_start:
    #in accordance with x86-64 parameters passed in registers
    movq $firststring, %rdi   #This is the format string
    movq $name, %rsi          #This is the first %s
    movq $personstring, %rdx  #This is the second %s
    movq numberloved, %rcx   #This is the %d
    movq $0, %rax             #no vector registers used (abi requirement of x86-64)
    #in the prototype
    call  printf
    
    movq $0, %rdi
    call  exit
    
    
