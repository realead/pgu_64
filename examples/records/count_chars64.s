#64bit

#
#INPUT:    The address of the character string (%rdi)
#
#OUTPUT:   Returns the count in %eax
#
#PROCESS:
#  Registers used:
#    %rcx - character count
#    %al - current character
#    %rdi - current character address

.type count_chars, @function
.globl count_chars
count_chars:
    #Counter starts at zero
    movq  $0, %rcx
count_loop_begin:
    #Grab the current character
    movb  (%rdi), %al
    #Is it null?
    cmpb  $0, %al
    #If yes, we’re done
    je    count_loop_end
    #Otherwise, increment the counter and the pointer
    incq  %rcx
    incq  %rdi
    #Go back to the beginning of the loop
    jmp   count_loop_begin
count_loop_end:
    #We’re done.  Move the count into %rax
    #and return.
    movq  %rcx, %rax
    ret
    
