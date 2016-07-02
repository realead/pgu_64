.include "linux32.s"
.include "record_def.s"

.section .data
input_file_name:
    .ascii "test.dat\0"
output_file_name:
    .ascii "testout.dat\0"
.section .bss
    .lcomm record_buffer, RECORD_SIZE
    #Stack offsets of local variables
    .equ ST_INPUT_DESCRIPTOR, -4
    .equ ST_OUTPUT_DESCRIPTOR, -8
.section .text
.globl _start
_start:
    #Copy stack pointer and make room for local variables
    movl  %esp, %ebp
    subl  $8, %esp
    #Open file for reading
    movl  $SYS_OPEN, %eax
    movl  $input_file_name, %ebx
    movl  $0, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)
    #Open file for writing
    movl  $SYS_OPEN, %eax
    movl  $output_file_name, %ebx
    movl  $0101, %ecx
    movl  $0666, %edx
    int   $LINUX_SYSCALL
    movl  %eax, ST_OUTPUT_DESCRIPTOR(%ebp)
loop_begin:
    pushl ST_INPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call  read_record
    addl  $8, %esp
    #Returns the number of bytes read.
    #If it isn’t the same number we
    #requested, then it’s either an
    #end-of-file, or an error, so we’re
    #quitting
    cmpl  $RECORD_SIZE, %eax
    jne   loop_end
    #Increment the age
    incl  record_buffer + RECORD_AGE
    #Write the record out
    pushl ST_OUTPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call  write_record
    addl  $8, %esp
    jmp   loop_begin
loop_end:
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
