.include "linux64.s"
.include "record_def.s"

.section .data
file_name:
    .ascii "test.dat\0"
.section .bss
    .lcomm record_buffer, RECORD_SIZE
.section .text
#Main program
.globl _start
_start:
    #These are the locations on the stack where
    #we will store the input and output descriptors
    #(FYI - we could have used memory addresses in
    #a .data section instead)
    .equ ST_INPUT_DESCRIPTOR, -8
    .equ ST_OUTPUT_DESCRIPTOR, -16
    
    #Copy the stack pointer to %rbp
    movq  %rsp, %rbp
    #Allocate space to hold the file descriptors
    subq  $16, %rsp
    #Open the file
    movq  $SYS_OPEN, %rax
    movq  $file_name, %rdi
    movq  $0, %rsi    #This says to open read-only
    movq  $0666, %rdx
    syscall
    
    #Save file descriptor
    movq  %rax, ST_INPUT_DESCRIPTOR(%rbp)
    #Even though it’s a constant, we are
    #saving the output file descriptor in
    #a local variable so that if we later
    #decide that it isn’t always going to
    #be STDOUT, we can change it easily.
    movq  $STDOUT, ST_OUTPUT_DESCRIPTOR(%rbp)
    
record_read_loop:
    movq ST_INPUT_DESCRIPTOR(%rbp), %rdi
    movq $record_buffer, %rsi
    call  read_record
    
    #Returns the number of bytes read.
    #If it isn’t the same number we
    #requested, then it’s either an
    #end-of-file, or an error, so we’re
    #quitting
    cmpq  $RECORD_SIZE, %rax
    jne   finished_reading
    #Otherwise, print out the first name
    #but first, we must know it’s size
    movq    $RECORD_FIRSTNAME + record_buffer, %rdi
    call   count_chars
    
    movq   %rax, %rdx                       #remember the size of the message
    movq   $SYS_WRITE, %rax                 #write
    movq   ST_OUTPUT_DESCRIPTOR(%rbp), %rdi #to this file
    movq   $RECORD_FIRSTNAME + record_buffer, %rsi #this message
    syscall
    
    movq  ST_OUTPUT_DESCRIPTOR(%rbp), %rsi
    call   write_newline
    
    jmp    record_read_loop
    
finished_reading:
    #Exit the program
    movq $SYS_EXIT, %rax
    movq  $0, %rdi
    syscall

