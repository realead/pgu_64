#PURPOSE:  Count the characters until a null byte is reached.
#
#INPUT:    The address of the character string
#
#OUTPUT:   Returns the count in %eax
#
#PROCESS:
#  Registers used:
#    %ecx - character count
#    %al - current character
#    %edx - current character address

.type count_chars, @function
.globl count_chars
    #This is where our one parameter is on the stack
    .equ ST_STRING_START_ADDRESS, 8
count_chars:
    pushl %ebp
    movl  %esp, %ebp
    #Counter starts at zero
    movl  $0, %ecx
    #Starting address of data
    movl  ST_STRING_START_ADDRESS(%ebp), %edx
count_loop_begin:
    #Grab the current character
    movb  (%edx), %al
    #Is it null?
    cmpb  $0, %al
    #If yes, we’re done
    je    count_loop_end
    #Otherwise, increment the counter and the pointer
    incl  %ecx
    incl  %edx
    #Go back to the beginning of the loop
    jmp   count_loop_begin
count_loop_end:
    #We’re done.  Move the count into %eax
    #and return.
    movl  %ecx, %eax
    popl  %ebp
    ret
