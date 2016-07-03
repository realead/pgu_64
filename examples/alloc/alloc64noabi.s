#64bit

#Attention: not abi conform

#Changes compared to 32 bit:
#
#use .quad instead of .long

.include "linux64.h"
#PURPOSE: Program to manage memory usage - allocates
#and deallocates memory as requested
#
#NOTES: The programs using these routines will ask
# for a certain size of memory. We actually
#use more than that size, but we put it
#at the beginning, before the pointer
#we hand back. We add a size field and
#an AVAILABLE/UNAVAILABLE marker. So, the
#memory looks like this
#
# #########################################################
# #Available Marker#Size of memory#Actual memory locations#
# #########################################################
#^--Returned pointer
#points here
#The pointer we return only points to the actual
#locations requested to make it easier for the
#calling program. It also allows us to change our
#structure without the calling program having to
#change at all.

.section .data
#######GLOBAL VARIABLES########
#This points to the beginning of the memory we are managing
heap_begin:
    .quad 0
#This points to one location past the memory we are managing
current_break:
    .quad 0
######STRUCTURE INFORMATION####
#size of space for memory region header
    .equ HEADER_SIZE, 16
#Location of the "available" flag in the header
    .equ HDR_AVAIL_OFFSET, 0
#Location of the size field in the header
    .equ HDR_SIZE_OFFSET, 8
###########CONSTANTS###########
    .equ UNAVAILABLE, 0 #This is the number we will use to mark
#space that has been given out
    .equ AVAILABLE, 1
    
.section .text

##########FUNCTIONS############
##allocate_init##
#PURPOSE: call this function to initialize the
#functions (specifically, this sets heap_begin and
#current_break). This has no parameters and no
#return value.
    .globl allocate_init
    .type allocate_init,@function
allocate_init:
    pushq %rbp              #standard function stuff
    movq %rsp, %rbp
    
    
    movq $SYS_BRK, %rax
    #find out where the break is
    movq $0, %rdi       #If the brk system call is called with 0 in %rbx, it
                        #returns the last valid usable address
    syscall
    
    incq %rax   #%rax now has the last valid
                #address, and we want the
                #memory location after that
     
    movq %rax, current_break #store the current break
    movq %rax, heap_begin    #store the current break as our    
                             #first address. This will cause
                             #the allocate function to get
                             #more memory from Linux the
                             #first time it is run
    movq %rbp, %rsp
    popq %rbp
    ret
#####END OF FUNCTION#######


##allocate##
#PURPOSE:This function is used to grab a section of
#memory. It checks to see if there are any
#free blocks, and, if not, it asks Linux
#for a new one.
#
#PARAMETERS: This function has one parameter - the size
#of the memory block we want to allocate
#
#RETURN VALUE:
#his function returns the address of the
#allocated memory in %rax. If there is no
#memory available, it will return 0 in %rax
#

######PROCESSING########
#Variables used:
#
#%rcx - hold the size of the requested memory
#(first/only parameter)
#%rax - current memory region being examined
#%rbx - current break position
#%rdx - size of current memory region
#
#We scan through each memory region starting with
#heap_begin. We look at the size of each one, and if
#it has been allocated. If it’s big enough for the
#requested size, and its available, it grabs that one.
#If it does not find a region large enough, it asks
#Linux for more memory. In that case, it moves
#current_break up

    .globl allocate
    .type allocate,@function
    .equ ST_MEM_SIZE, 16 #stack position of the memory size
                        #to allocate
allocate:
    pushq %rbp                   #standard function stuff
    movq %rsp, %rbp
    movq ST_MEM_SIZE(%rbp), %rcx #%rcx will hold the size
                                 #we are looking for (which is the first
                                 #and only parameter)
    movq heap_begin, %rax       #%rax will hold the current
                                #search location
    movq current_break, %rbx    #%rbx will hold the current
                                #break
alloc_loop_begin:           #here we iterate through each
                            #memory region
    cmpq %rbx, %rax         #need more memory if these are equal
    je move_break
    
    
    #grab the size of this memory
    movq HDR_SIZE_OFFSET(%rax), %rdx
    
    #If the space is unavailable, go to the
    cmpq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)
    je  next_location   #next one

    cmpq %rdx, %rcx     #If the space is available, compare
    jle allocate_here   #the size to the needed size. If its
                        #big enough, go to allocate_here

next_location:
    addq $HEADER_SIZE, %rax     #The total size of the memory
    addq %rdx, %rax             #region is the sum of the size
                                #requested (currently stored
                                #in %rdx), plus another 8 bytes
                                #for the header (4 for the
                                #AVAILABLE/UNAVAILABLE flag,
                                #and 4 for the size of the
                                #region). So, adding %rdx and $8
                                #to %rax will get the address
                                #of the next memory region
    
    jmp alloc_loop_begin        #go look at the next location

allocate_here:              #if we’ve made it here,
                            #that means that the
                            #region header of the region
                            #to allocate is in %rax
                            
    #mark space as unavailable
    movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)
    addq $HEADER_SIZE, %rax     #move %rax past the header to
                                #the usable memory (since
                                #that’s what we return)
    movq    %rbp, %rsp
    popq    %rbp
    ret

move_break:                     #return from the function
                                #if we’ve made it here, that
                                #means that we have exhausted
                                #all addressable memory, and
                                #we need to ask for more.
                                #%rbx holds the current
                                #endpoint of the data,
                                #and %rcx holds its size

                    #we need to increase %rbx to
                    #where we _want_ memory
                    #to end, so we
    
    
    addq    $HEADER_SIZE, %rbx      #add space for the headers
                                    #structure
    addq    %rcx, %rbx              #add space to the break for
                                    #the data requested
                                    
                                    
                    #now its time to ask Linux
                    #for more memory
                    
    pushq %rax  #save needed registers
    pushq %rcx
    pushq %rbx 
    
    movq $SYS_BRK, %rax         #reset the break (%rbx has
    movq %rbx, %rdi             #the requested break point)
    syscall
        #under normal conditions, this should
        #return the new break in %rax, which
        #will be either 0 if it fails, or
        #it will be equal to or larger than
        #we asked for. We don’t care
        #in this program where it actually
        #sets the break, so as long as %rax
        #isn’t 0, we don’t care what it is
        
    cmpq $0, %rax   #check for error conditions
    je error 
    
    popq    %rbx    #restore saved registers
    popq    %rcx 
    popq    %rax
    
    #set this memory as unavailable, since we’re about to
    #give it away
    movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)
    #set the size of the memory
    movq %rcx, HDR_SIZE_OFFSET(%rax)
    
    #move %rax to the actual start of usable memory.
    #%rax now holds the return value
    addq $HEADER_SIZE, %rax
    
    movq %rbx, current_break #save the new break
    
    movq %rbp, %rsp
    popq %rbp #return the function
    ret 
error:
    movq $0, %rax
    #on error, we return zero
    movq %rbp, %rsp
    popq %rbp
    ret
########END OF FUNCTION########


##deallocate##
#PURPOSE:
#The purpose of this function is to give back
#a region of memory to the pool after we’re done
#using it.
#
#PARAMETERS:
#The only parameter is the address of the memory
#we want to return to the memory pool.
#
#RETURN VALUE:
#There is no return value
#
#PROCESSING:
#If you remember, we actually hand the program the
#start of the memory that they can use, which is
#8 storage locations after the actual start of the
#memory region. All we have to do is go back
#8 locations and mark that memory as available,
#so that the allocate function knows it can use it.

    .globl deallocate
    .type deallocate,@function
#stack position of the memory region to free
    .equ ST_MEMORY_SEG, 8
deallocate:
    #since the function is so simple, we
    #don’t need any of the fancy function stuff
    #get the address of the memory to free
    #(normally this is 8(%rbp), but since
    #we didn’t push %rbp or move %rsp to
    #%rbp, we can just do 4(%rsp)
    
    movq ST_MEMORY_SEG(%rsp), %rax
    
    #get the pointer to the real beginning of the memory
    subq $HEADER_SIZE, %rax
    
    #mark it as available
    movq $AVAILABLE, HDR_AVAIL_OFFSET(%rax)
    #return
    ret
########END OF FUNCTION##########
