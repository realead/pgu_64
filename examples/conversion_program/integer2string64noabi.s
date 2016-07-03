#PURPOSE: Convert an integer number to a decimal string
#for display
#
#INPUT: A buffer large enough to hold the largest
#possible number
#An integer to convert
#
#OUTPUT: The buffer will be overwritten with the
#decimal string
#
#Variables:
#
# %rcx will hold the count of characters processed
# %rax will hold the current value
# %rdi will hold the base (10)
#
.equ ST_VALUE, 16
.equ ST_BUFFER, 24
    .globl integer2string
    .type integer2string, @function
integer2string:
    #Normal function beginning
    pushq %rbp
    movq %rsp, %rbp
    
    #Current character count
    movq $0, %rcx
    
    #Move the value into position
    movq ST_VALUE(%rbp), %rax
    
    #When we divide by 10, the 10
    #must be in a register or memory location
    movq $10, %rdi
    
conversion_loop:
    #Division is actually performed on the
    #combined %rdx:%rax register, so first
    #clear out %rdx
    movq $0, %rdx
    
    #Divide %rdx:%rax (which are implied) by 10.
    #Store the quotient in %rax and the remainder
    #in %rdx (both of which are implied).
    divq %rdi
    
    #Quotient is in the right place. %rdx has
    #the remainder, which now needs to be converted
    #into a number. So, %rdx has a number that is
    #0 through 9. You could also interpret this as
    #an index on the ASCII table starting from the
    #character ’0’. The ascii code for ’0’ plus zero
    #is still the ascii code for ’0’. The ascii code
    #for ’0’ plus 1 is the ascii code for the
    #character ’1’. Therefore, the following
    #instruction will give us the character for the
    #number stored in %rdx
    addq $'0', %rdx
    
    #Now we will take this value and push it on the
    #stack. This way, when we are done, we can just
    #pop off the characters one-by-one and they will
    #be in the right order. Note that we are pushing
    #the whole register, but we only need the byte
    #in %dl (the last byte of the %rdx register) for
    #the character.
    pushq %rdx
    
    #Increment the digit count
    incq %rcx
    
    #Check to see if %rax is zero yet, go to next
    #step if so.
    cmpq $0, %rax
    je end_conversion_loop
    
    #%rax already has its new value.
    jmp conversion_loop
    
end_conversion_loop:
    #The string is now on the stack, if we pop it
    #off a character at a time we can copy it into
    #the buffer and be done.
    #Get the pointer to the buffer in %rdx
    movq ST_BUFFER(%rbp), %rdx
    
copy_reversing_loop:
    #We pushed a whole register, but we only need
    #the last byte. So we are going to pop off to
    #the entire %rax register, but then only move the
    #small part (%al) into the character string.
    popq %rax
    movb %al, (%rdx)
    
    #Decreasing %rcx so we know when we are finished
    decq %rcx
    #Increasing %rdx so that it will be pointing to
    #the next byte
    incq %rdx
    
    #Check to see if we are finished
    cmpq $0, %rcx
    #If so, jump to the end of the function
    je end_copy_reversing_loop
    #Otherwise, repeat the loop
    jmp copy_reversing_loop
    
end_copy_reversing_loop:
    #Done copying. Now write a null byte and return
    movb $0, (%rdx)
    movq  %rbp, %rsp
    popq  %rbp
    ret
    
    
