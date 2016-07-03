########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}
VARIANT=$2
DIR="printf_example"


########### BUILD ####################:
#compile:
TARGET="$DIR/$DIR$ARCH$VARIANT"
SRC="$TARGET.s"
OBJ="$TARGET.o"

as --$ARCH  $SRC -o $OBJ

#link:
if [ $ARCH = "32" ] ; then
        LD_FLAG="-melf_i386"
        DYN_LINKER="/lib/ld-linux.so.2"
else
        LD_FLAG="-melf_x86_64"
        DYN_LINKER="/lib64/ld-linux-x86-64.so.2"
fi
    
ld -o $TARGET $LD_FLAG -dynamic-linker $DYN_LINKER $OBJ -lc  



