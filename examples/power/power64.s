#64bit version

#ATTENTION: this is not x86-64 abi conform; see power64_nostack.s for an abi conform call of function power.
#           however, because power is not global it is not a problem  


#changes compared to 32bit:
#
# 1. 4byte registers -> 8byte registers
# 2. scale all adresses by factor 2 i.e. 4->8, 8->16, 12->24
# 2. uses movq, decq  and so on instead of version with l
# 3. rax value for interupt is 60 (not 1 as for 32bit)
# 4. rdi holds the return status (not ebx as for 32bit)
# 5. int $0x080  -> syscall
# 

#PURPOSE:  Program to illustrate how functions work
#          This program will compute the value of
#          2^3 + 5^2
#
#Everything in the main program is stored in registers,
#so the data section doesn’t have anything.
.section .data


.section .text
.globl _start

_start:
    pushq $3                  #push second argument
    pushq $2                  #push first argument
    call  power               #call the function
    addq  $16, %rsp           #move the stack pointer back

    pushq %rax                #save the first answer before
                              #calling the next function
    pushq $2                  #push second argument
    pushq $5                  #push first argument
    call  power               #call the function
    addq  $16, %rsp           #move the stack pointer back
    popq  %rdi                #The second answer is already
                              #in %rax.  We saved the
                              #first answer onto the stack,
                              #so now we can just pop it
                              #out into %rdi (this register will be set up for syscall)
    addq  %rax, %rdi          #add them together
                              #the result is in %ebx
    movq  $60, %rax           #exit (%rdi is returned)
    syscall


#PURPOSE:  This function is used to compute
#          the value of a number raised to
#          a power.
#
#INPUT:    First argument - the base number
#          Second argument - the power to
#                            raise it to
#
#OUTPUT:   Will give the result as a return value
#
#NOTES:    The power must be 1 or greater
#
#VARIABLES:
#          %rbx - holds the base number
#          %rcx - holds the power
#
#          -8(%rbp) - holds the current result
#
#          %rax is used for temporary storage
#
.type power, @function
power:
    pushq %rbp           #save old base pointer
    movq  %rsp, %rbp     #make stack pointer the base pointer
    subq  $8, %rsp       #get room for our local storage
    movq  16(%rbp), %rbx #put first argument in %rax
    movq  24(%rbp), %rcx #put second argument in %rcx
    movq  %rbx, -8(%rbp) #store current result
power_loop_start:
    cmpq  $1, %rcx       #if the power is 1, we are done
    je    end_power
    movq  -8(%rbp), %rax #move the current result into %rax
    imulq %rbx, %rax     #multiply the current result by
                         #the base number
    movq  %rax, -8(%rbp) #store the current result
    decq  %rcx           #decrease the power
    jmp   power_loop_start #run for the next power

end_power:
    movq -8(%rbp), %rax  #return value goes in %rax
    movq %rbp, %rsp      #restore the stack pointer
    popq %rbp            #restore the base pointer
    ret
    
