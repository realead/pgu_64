########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')


ARCH=${1:-"64"}
VARIANT=$2
SRCDIR="alloc_shared"
OBJDIR=$SRCDIR

SHARED_LIB=myalloc

#first parameter - source files
build_sharedlib(){
    if [ $ARCH = "32" ] ; then
        LD_FLAG="-melf_i386"
        DYN_LINKER="/lib/ld-linux.so.2"
    else
        LD_FLAG="-melf_x86_64"
        DYN_LINKER="/lib64/ld-linux-x86-64.so.2"
    fi
    TARGET="$OBJDIR/lib$SHARED_LIB$ARCH$VARIANT.so"
    OBJECTS=""
    for name in $1
    do
         SRC="$SRCDIR/$name$ARCH$VARIANT.s"
         OBJ="$OBJDIR/$name$ARCH$VARIANT.o"
         OBJECTS="$OBJECTS $OBJ"
         as -Iincludes --$ARCH  $SRC -o $OBJ
    done
    ld -shared $LD_FLAG -o $TARGET $LD_FLAG -dynamic-linker $DYN_LINKER $OBJECTS -lc
}

########### BUILD ####################:
#shared_lib:
echo "building shared library..."
FILES_SHARED="alloc"
build_sharedlib "$FILES_SHARED"

########### BUILD ####################:
#compile:
echo "building exe..."
gcc -m$ARCH $SRCDIR/alloc_shared.c -o $OBJDIR/alloc_shared$ARCH$VARIANT  



