#!/bin/sh

# run "sh build_and_run.sh XXX" or  "sh build_and_run.sh XXX 64"  for building, running and cleaning up example XXX in 64 bit mode
# run "sh build_and_run.sh XXX 32"  for building, running and cleaning up example XXX in 32 bit mode 



########## ANALISE OPTIONS ###############:
# $1 - name of the example
# $2 - architecture (optional, default 64)
# $3 - variant (optional, default '')
ARCH=${2:-"64"}
TARGET=$1/$1$ARCH$3
SOURCE=$TARGET.s
OBJECT=$TARGET.o

RUN_SCRIPT="$1/run.sh"

   
########### BUILD ####################:

#as in the book:
if [ $ARCH = "32" ] ; then
    LD_FLAG="-melf_i386"
else
    LD_FLAG="-melf_x86_64"
fi    
 
as --$ARCH $SOURCE -o $OBJECT
ld $LD_FLAG $OBJECT -o $TARGET

    
# another possibility:
#gcc -nostdlib -m$ARCH $SOURCE -o $TARGET 


############ RUN ###################:
if [ -e  $RUN_SCRIPT ] ; then
    sh $RUN_SCRIPT $ARCH $3
else
    ./$TARGET
    echo "$TARGET : $?"
fi


############## CLEAN UP ########################:
rm $OBJECT
rm $TARGET

