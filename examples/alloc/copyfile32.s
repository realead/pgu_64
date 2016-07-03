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

.include "linux32.h"
.section .data
#######CONSTANTS########
    .equ O_RDONLY, 0
    .equ O_CREAT_WRONLY_TRUNC, 03101
    .equ NUMBER_ARGUMENTS, 2
    .equ BUFFER_SIZE, 5
record_buffer_ptr:
    .long 0
    
.section .text
#STACK POSITIONS
    .equ ST_SIZE_RESERVE, 8
    .equ ST_FD_IN, -4
    .equ ST_FD_OUT, -8
    .equ ST_ARGC, 0      #Number of arguments
    .equ ST_ARGV_0, 4   #Name of program
    .equ ST_ARGV_1, 8   #Input file name
    .equ ST_ARGV_2, 12   #Output file name
.globl _start
_start:
###INITIALIZE PROGRAM###
#save the stack pointer
    movl  %esp, %ebp
    
    call allocate_init
    pushl $BUFFER_SIZE
    call allocate
    movl %eax, record_buffer_ptr
    addl $4, %esp
    
#Allocate space for our file descriptors
#on the stack
    subl  $ST_SIZE_RESERVE, %esp
open_files:
open_fd_in:
###OPEN INPUT FILE###
  #open syscall
    movl  $SYS_OPEN, %eax
    #input filename into %ebx
    movl  ST_ARGV_1(%ebp), %ebx
  #read-only flag
    movl  $O_RDONLY, %ecx
    #this doesn’t really matter for reading
    movl  $0666, %edx
    #call Linux
    int   $LINUX_SYSCALL
store_fd_in:
    #save the given file descriptor
    movl  %eax, ST_FD_IN(%ebp)
open_fd_out:
###OPEN OUTPUT FILE###
    #open the file
    movl  $SYS_OPEN, %eax
    #output filename into %ebx
    movl  ST_ARGV_2(%ebp), %ebx
    #flags for writing to the file
    movl  $O_CREAT_WRONLY_TRUNC, %ecx
    #mode for new file (if it’s created)
    movl  $0666, %edx
    #call Linux
    int   $LINUX_SYSCALL
store_fd_out:
    #store the file descriptor here
    movl  %eax, ST_FD_OUT(%ebp)
    
###BEGIN MAIN LOOP###
read_loop_begin:
    ###READ IN A BLOCK FROM THE INPUT FILE###
    movl  $SYS_READ, %eax
    #get the input file descriptor
    movl  ST_FD_IN(%ebp), %ebx
    #the location to read into
    movl  record_buffer_ptr, %ecx
    #the size of the buffer
    movl  $BUFFER_SIZE, %edx
    #Size of buffer read is returned in %eax
    int   $LINUX_SYSCALL
    ###EXIT IF WE’VE REACHED THE END###
    #check for end of file marker
    cmpl  $END_OF_FILE, %eax
    #if found or on error, go to the end
    jle   end_loop

continue_read_loop:
###WRITE THE BLOCK OUT TO THE OUTPUT FILE###
    #size of the buffer
    movl  %eax, %edx
    movl  $SYS_WRITE, %eax
    #file to use
    movl  ST_FD_OUT(%ebp), %ebx
    #location of the buffer
    movl  record_buffer_ptr, %ecx
    int   $LINUX_SYSCALL
    ###CONTINUE THE LOOP###
    jmp   read_loop_begin
end_loop:
    ###CLOSE THE FILES###
    #NOTE - we don’t need to do error checking
    #       on these, because error conditions
    #       don’t signify anything special here
    movl  $SYS_CLOSE, %eax
    movl  ST_FD_OUT(%ebp), %ebx
    int   $LINUX_SYSCALL
    movl  $SYS_CLOSE, %eax
    movl  ST_FD_IN(%ebp), %ebx
    int   $LINUX_SYSCALL
    ###EXIT###
    #dealocate memory:
    pushl record_buffer_ptr
    call deallocate

    #exit:
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
 
