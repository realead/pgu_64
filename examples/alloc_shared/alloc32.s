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
    .long 0
#This points to one location past the memory we are managing
current_break:
    .long 0
message_ini:
    .ascii "my_ini\n\0"
message_malloc:
    .ascii "my_malloc\n\0"
message_free:
    .ascii "my_free\n\0"
    
######STRUCTURE INFORMATION####
#size of space for memory region header
    .equ HEADER_SIZE, 8
#Location of the "available" flag in the header
    .equ HDR_AVAIL_OFFSET, 0
#Location of the size field in the header
    .equ HDR_SIZE_OFFSET, 4
###########CONSTANTS###########
    .equ UNAVAILABLE, 0 #This is the number we will use to mark
#space that has been given out
    .equ AVAILABLE, 1
#This is the number we will use to mark
#space that has been returned, and is
#available for giving
    .equ SYS_BRK, 45
#system call number for the break
#system call
    .equ LINUX_SYSCALL, 0x80 #make system calls easier to read
    
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
    pushl %ebp              #standard function stuff
    movl %esp, %ebp
    
    pushl $message_ini
    call printf
    addl $4, %esp
    
    movl $SYS_BRK, %eax
    #find out where the break is
    movl $0, %ebx       #If the brk system call is called with 0 in %ebx, it
                        #returns the last valid usable address
    int $LINUX_SYSCALL
    incl %eax #%eax now has the last valid
    #address, and we want the
    #memory location after that
     
    movl %eax, current_break #store the current break
    movl %eax, heap_begin    #store the current break as our    
                             #first address. This will cause
                             #the allocate function to get
                             #more memory from Linux the
                             #first time it is run
    movl %ebp, %esp
    popl %ebp
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
#allocated memory in %eax. If there is no
#memory available, it will return 0 in %eax
#

######PROCESSING########
#Variables used:
#
#%ecx - hold the size of the requested memory
#(first/only parameter)
#%eax - current memory region being examined
#%ebx - current break position
#%edx - size of current memory region
#
#We scan through each memory region starting with
#heap_begin. We look at the size of each one, and if
#it has been allocated. If it’s big enough for the
#requested size, and its available, it grabs that one.
#If it does not find a region large enough, it asks
#Linux for more memory. In that case, it moves
#current_break up

    .globl malloc
    .type malloc,@function
    .equ ST_MEM_SIZE, 8 #stack position of the memory size
                        #to allocate
malloc:
    pushl %ebp #standard function stuff
    movl %esp, %ebp
    
    #if heap not set call allocate
    
    cmpl $0, heap_begin
    jne no_init
    
    call allocate_init 
    
no_init:    
    
    pushl $message_malloc
    call printf
    addl $4, %esp
    
    movl ST_MEM_SIZE(%ebp), %ecx #%ecx will hold the size
                                 #we are looking for (which is the first
                                 #and only parameter)
    movl heap_begin, %eax       #%eax will hold the current
                                #search location
    movl current_break, %ebx    #%ebx will hold the current
                                #break
alloc_loop_begin:           #here we iterate through each
                            #memory region
    cmpl %ebx, %eax         #need more memory if these are equal
    je move_break
    
    
    #grab the size of this memory
    movl HDR_SIZE_OFFSET(%eax), %edx
    
    #If the space is unavailable, go to the
    cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
    je  next_location   #next one

    cmpl %edx, %ecx     #If the space is available, compare
    jle allocate_here   #the size to the needed size. If its
                        #big enough, go to allocate_here

next_location:
    addl $HEADER_SIZE, %eax     #The total size of the memory
    addl %edx, %eax             #region is the sum of the size
                                #requested (currently stored
                                #in %edx), plus another 8 bytes
                                #for the header (4 for the
                                #AVAILABLE/UNAVAILABLE flag,
                                #and 4 for the size of the
                                #region). So, adding %edx and $8
                                #to %eax will get the address
                                #of the next memory region
    
    jmp alloc_loop_begin        #go look at the next location

allocate_here:              #if we’ve made it here,
                            #that means that the
                            #region header of the region
                            #to allocate is in %eax
                            
    #mark space as unavailable
    movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
    addl $HEADER_SIZE, %eax     #move %eax past the header to
                                #the usable memory (since
                                #that’s what we return)
    movl    %ebp, %esp
    popl    %ebp
    ret

move_break:                     #return from the function
                                #if we’ve made it here, that
                                #means that we have exhausted
                                #all addressable memory, and
                                #we need to ask for more.
                                #%ebx holds the current
                                #endpoint of the data,
                                #and %ecx holds its size

                    #we need to increase %ebx to
                    #where we _want_ memory
                    #to end, so we
    
    
    addl    $HEADER_SIZE, %ebx      #add space for the headers
                                    #structure
    addl    %ecx, %ebx              #add space to the break for
                                    #the data requested
                                    
                                    
                    #now its time to ask Linux
                    #for more memory
                    
    pushl %eax  #save needed registers
    pushl %ecx
    pushl %ebx 
    
    movl $SYS_BRK, %eax #reset the break (%ebx has
    #the requested break point)
    int $LINUX_SYSCALL
        #under normal conditions, this should
        #return the new break in %eax, which
        #will be either 0 if it fails, or
        #it will be equal to or larger than
        #we asked for. We don’t care
        #in this program where it actually
        #sets the break, so as long as %eax
        #isn’t 0, we don’t care what it is
        
    cmpl $0, %eax   #check for error conditions
    je error 
    
    popl    %ebx    #restore saved registers
    popl    %ecx 
    popl    %eax
    
    #set this memory as unavailable, since we’re about to
    #give it away
    movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
    #set the size of the memory
    movl %ecx, HDR_SIZE_OFFSET(%eax)
    
    #move %eax to the actual start of usable memory.
    #%eax now holds the return value
    addl $HEADER_SIZE, %eax
    
    movl %ebx, current_break #save the new break
    
    movl %ebp, %esp
    popl %ebp #return the function
    ret 
error:
    movl $0, %eax
    #on error, we return zero
    movl %ebp, %esp
    popl %ebp
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

    .globl free
    .type free,@function
#stack position of the memory region to free
    .equ ST_MEMORY_SEG, 8
free:
    #since the function is so simple, we
    #don’t need any of the fancy function stuff
    #get the address of the memory to free
    #(normally this is 8(%ebp), but since
    #we didn’t push %ebp or move %esp to
    #%ebp, we can just do 4(%esp)
    
    pushl %ebp #standard function stuff
    movl %esp, %ebp
    
    pushl $message_free
    call printf
    addl $4, %esp 
    
    movl ST_MEMORY_SEG(%esp), %eax
    
    #get the pointer to the real beginning of the memory
    subl $HEADER_SIZE, %eax
    
    #mark it as available
    movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
    
    #return
    movl %ebp, %esp
    popl %ebp #return the function
    ret
########END OF FUNCTION##########
