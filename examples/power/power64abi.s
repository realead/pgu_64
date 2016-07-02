#64bit version
#
# x86-64-ABI comform call of function power see http://www.x86-64.org/documentation_folder/abi.pdf
#
#changes:
#   1. the arguments are passed not via stack but via registers
#   2. power function does not use stack at all
#   3. power function calcs also a^0 correctly
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
    movq $3, %rsi             #push second argument
    movq $2, %rdi             #push first argument
    call  power               #call the function
    
    pushq %rax                #save the first answer before
                              #calling the next function
    movq $2, %rsi             #push second argument
    movq $5, %rdi             #push first argument
    call  power               #call the function
    
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
#          %rdi - holds the base number
#          %rsi - holds the power
#
#          -8(%rbp) - holds the current result
#
#          %rax is used for temporary storage
#
.type power, @function
power:
    #we do no use stack, so we do not change %rbp, %rsp
    movq $1, %rax #result in rax
power_loop_start:
    cmpq  $0, %rsi         #if the power is 0, we are done
    je    end_power
    imulq %rdi, %rax       #multiply the current result by
                           #the base number
    decq  %rsi             #decrease the power
    jmp   power_loop_start #run for the next power

end_power:
    ret
    
