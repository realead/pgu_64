########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}

########### BUILD ####################:

if [ $ARCH = "32" ] ; then
    LD_FLAG="-melf_i386"
else
    LD_FLAG="-melf_x86_64"
fi    

TARGET="records/write_records$ARCH"
FILE1=$TARGET
FILE2="records/write_record$ARCH"
 
as -I records --$ARCH  "$FILE1.s" -o "$FILE1.o"
as -I records --$ARCH  "$FILE2.s" -o "$FILE2.o"
ld $LD_FLAG "$FILE1.o"  "$FILE2.o" -o $TARGET


