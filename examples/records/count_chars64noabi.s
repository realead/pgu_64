#64bit no abi


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
    .equ ST_STRING_START_ADDRESS, 16
count_chars:
    pushq %rbp
    movq  %rsp, %rbp
    #Counter starts at zero
    movq  $0, %rcx
    #Starting address of data
    movq  ST_STRING_START_ADDRESS(%rbp), %rdx
count_loop_begin:
    #Grab the current character
    movb  (%rdx), %al
    #Is it null?
    cmpb  $0, %al
    #If yes, we’re done
    je    count_loop_end
    #Otherwise, increment the counter and the pointer
    incq  %rcx
    incq  %rdx
    #Go back to the beginning of the loop
    jmp   count_loop_begin
count_loop_end:
    #We’re done.  Move the count into %rax
    #and return.
    movq  %rcx, %rax
    popq  %rbp
    ret
    
