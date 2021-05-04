# pgu_64
Programming Ground Up for x86-64 architecture

### Info

"Programming Ground Up" (http://nongnu.askapache.com/pgubook/ProgrammingGroundUp-1-0-booksize.pdf) is a great source for starting out assembler programming. However its code is for x86. This project migrates the programs from this book to x86-64 architecture.

"Programming under the hood" (https://github.com/johnnyb/programming_under_the_hood) is a follow-up from the same author, which also touches the x86-64 architecture.

### Infrastructure

There are differences between x86 and x86-64 in the Application Binary Interface (ABI,  http://www.x86-64.org/documentation/abi.pdf), not all of them are important as long as your code does not interact with other libraries/other code.

 So there are 3 flavors of code: 32bit, 64bit abi conform, and 64bit abi nonconform. For some examples there are no 64bit noabi version because it would be the same as the abi conform version (i.e. no function calls involved).
 
Individual example (e.g. *power*) can be run via
   1. *sh build_and_run.sh power 64* for abi conform 64 bit version (it is also the default if no argument is passed to the script)
   2. *sh build_and_run.sh power 64 noabi* for abi nonconform 64 bit version. Be aware that not all examples has this version.
   3. *sh build_and_run.sh power 32* for 32 bit version.
   
It is also possible to run all examples by calling  *sh test_all.sh 64*,  *sh test_all.sh 64 noabi* or  *sh test_all.sh 32*.

### Example description

#### Chapter 3: exit
    
The following should be considered:
   1. eXX register -> rXX 
   2. xxxl -> xxxq (e.g. movl -> movq)
   3. int $0x80  -> syscall
   4. constants/parameters for int $0x80 and syscall are different
   

#### Chapter 4:  power, factorial

Additional to the things in the previous chapter, the following should be considered:
   1. Different abi: the parameter of the functions are passed via registers (%rdi, %rsi and so on)  and not via stack, as it is the case for x86.
   2. offset on the stack are no longer multiple of 4bytes but of 8bytes.
   
### Chapter 5: toupper 
Additional things to consider:
   1. syscall constants for open/close/write/read file differ from x86 constants.
   
### Chapter 6: records 
*add_year_error_handled* is not a part of chapter 6, but chapter 7
   
### Chapter 7: records
only *add_year_error_handled*.
   
### Chapter 8: hello_world_nolib, hello_world_lib, printf_example, records_shared
Additional things to consider:
   1. Using *printf*, the abi demands, that for function with variable number of arguments (*printf* is one of them), the number of used vector registers is passed in *%al* (which was not the case for x86).
   2. In example *records_shared*, the files with local data (*write_newline*, *error_exit*) are not in the shared library, because for x86-64 position indipendent code (PIC) is needed for shared libraries. This issue is handled in example *alloc_shared*.
   3. Be aware, that when using clib-`printf` also clib-`exit` must be used. See also http://stackoverflow.com/questions/38379553/using-printf-in-assembly-leads-to-an-empty-ouput

You might need to install *gcc-multilib* to run shared examples. See trooubleshooting section for more information.

### Chapter 9: alloc, alloc_shared
Additional things to consider: 
  1. shared libraries need PIC-code, thus the following should be done: instead of *$my_data_field* the expression *my_data_field(%rip)* should be used for local data. For global data fields used *(my_data_field@GOTPCREL(%rip))* to make sure, that the right *my_data_field* is used.
  2. call functions via *call printf@PLT* or *call malloc@PLT* (because malloc is .globl)
  3. call functions via *call allocation_init* if they are not global
  4. SYS_BRK has other value for *syscall* as for *int*.

### Chapter 10: conversion_program
Nothing new to consider, all things needed for the translation have been mentioned in previous chapters.


### Troubleshooting

32bit doesn't work on your 64bit machine you might need to install gcc-multilib:

*sudo apt-get install gcc-multilib*

