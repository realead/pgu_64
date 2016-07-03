#PURPOSE: This program converts an input file
#            to an output file with all letters
#            converted to uppercase.
#
#PROCESSING: 1) Open the input file
#            2) Open the output file
#            4) While we’re not at the end of the input file
#               a) read part of file into our memory buffer
#               b) go through each byte of memory
#                    if the byte is a lower-case letter,
#                    convert it to uppercase
#               c) write the memory buffer to output file

.include "linux64.h"
.section .data
#######CONSTANTS########
    .equ O_RDONLY, 0
    .equ O_CREAT_WRONLY_TRUNC, 03101
    .equ NUMBER_ARGUMENTS, 2
    .equ BUFFER_SIZE, 5
record_buffer_ptr:
    .quad 0
    
.section .text
#STACK POSITIONS
    .equ ST_SIZE_RESERVE, 16
    .equ ST_FD_IN, -8
    .equ ST_FD_OUT, -16
    .equ ST_ARGC, 0      #Number of arguments
    .equ ST_ARGV_0, 8   #Name of program
    .equ ST_ARGV_1, 16   #Input file name
    .equ ST_ARGV_2, 24   #Output file name
.globl _start
_start:
###INITIALIZE PROGRAM###
#save the stack pointer
    movq  %rsp, %rbp

    call allocate_init
    pushq $BUFFER_SIZE
    call allocate
    movq %rax, record_buffer_ptr
    addq $8, %rsp
    
#Allocate space for our file descriptors
#on the stack
    subq  $ST_SIZE_RESERVE, %rsp
open_files:
open_fd_in:
###OPEN INPUT FILE###
  #open syscall
    movq  $SYS_OPEN, %rax
    movq  ST_ARGV_1(%rbp), %rdi
  #read-only flag
    movq  $O_RDONLY, %rsi
    #this doesn’t really matter for reading
    movq  $0666, %rdx
    syscall 
store_fd_in:
    #save the given file descriptor
    movq  %rax, ST_FD_IN(%rbp)
    
    
open_fd_out:
###OPEN OUTPUT FILE###
    #open the file
    movq  $SYS_OPEN, %rax
    movq  ST_ARGV_2(%rbp), %rdi
    #flags for writing to the file
    movq  $O_CREAT_WRONLY_TRUNC, %rsi
    #mode for new file (if it’s created)
    movq  $0666, %rdx
    syscall
store_fd_out:
    #store the file descriptor here
    movq  %rax, ST_FD_OUT(%rbp)
    
###BEGIN MAIN LOOP###
read_loop_begin:
    ###READ IN A BLOCK FROM THE INPUT FILE###
    movq  $SYS_READ, %rax
    movq  ST_FD_IN(%rbp), %rdi
    movq  record_buffer_ptr, %rsi
    movq  $BUFFER_SIZE, %rdx
    #Size of buffer read is returned in %rax
    syscall
    
    ###EXIT IF WE’VE REACHED THE END###
    #check for end of file marker
    cmpq  $END_OF_FILE, %rax
    #if found or on error, go to the end
    jle   end_loop

continue_read_loop:
###WRITE THE BLOCK OUT TO THE OUTPUT FILE###
    #size of the buffer
    movq  %rax, %rdx
    movq  $SYS_WRITE, %rax
    movq  ST_FD_OUT(%rbp), %rdi
    movq  record_buffer_ptr, %rsi
    syscall
    
    ###CONTINUE THE LOOP###
    jmp   read_loop_begin
end_loop:
    ###CLOSE THE FILES###
    #NOTE - we don’t need to do error checking
    #       on these, because error conditions
    #       don’t signify anything special here
    movq  $SYS_CLOSE, %rax
    movq  ST_FD_OUT(%rbp), %rdi
    syscall
    
    movq  $SYS_CLOSE, %rax
    movq  ST_FD_IN(%rbp), %rdi
    syscall
    
    ###EXIT###
    #dealocate memory:
    pushq record_buffer_ptr
    call deallocate

    #exit:
    movq  $SYS_EXIT, %rax
    movq  $0, %rdi
    syscall
 
