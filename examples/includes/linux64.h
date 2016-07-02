#######CONSTANTS########
#system call numbers

    .equ SYS_READ, 0
    .equ SYS_WRITE, 1
    .equ SYS_OPEN, 2
    .equ SYS_CLOSE, 3
    .equ SYS_EXIT, 60

    .equ O_RDONLY, 0
    .equ O_CREAT_WRONLY_TRUNC, 03101
    
#standard file descriptors
    .equ STDIN, 0
    .equ STDOUT, 1
    .equ STDERR, 2
    
    .equ END_OF_FILE, 0  
    
