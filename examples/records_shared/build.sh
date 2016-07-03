########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}
VARIANT=$2
SRCDIR="records"
OBJDIR="records_shared"

SHARED_LIB=record

#first parameter - source files
build_sharedlib(){
    if [ $ARCH = "32" ] ; then
        LD_FLAG="-melf_i386"
    else
        LD_FLAG="-melf_x86_64"
    fi
    TARGET="$OBJDIR/lib$SHARED_LIB$ARCH$VARIANT.so"
    OBJECTS=""
    for name in $1
    do
         SRC="$SRCDIR/$name$ARCH$VARIANT.s"
         OBJ="$OBJDIR/$name$ARCH$VARIANT.o"
         OBJECTS="$OBJECTS $OBJ"
         as -I$SRCDIR --$ARCH  $SRC -o $OBJ
    done
    ld -shared $LD_FLAG $OBJECTS -o $TARGET
}


#first parameter - target
#second parameter - source files
build_target(){
    if [ $ARCH = "32" ] ; then
        LD_FLAG="-melf_i386"      
        DYN_LINKER="/lib/ld-linux.so.2"
    else
        LD_FLAG="-melf_x86_64"
        DYN_LINKER="/lib64/ld-linux-x86-64.so.2"
    fi
    TARGET="$OBJDIR/$1$ARCH$VARIANT"
    OBJECTS=""
    for name in $2 
    do
         SRC="$SRCDIR/$name$ARCH$VARIANT.s"
         OBJ="$OBJDIR/$name$ARCH$VARIANT.o"
         OBJECTS="$OBJECTS $OBJ"
         as -I$SRCDIR --$ARCH  $SRC -o $OBJ
    done
    ld $LD_FLAG -L$OBJDIR -dynamic-linker $DYN_LINKER -o $TARGET  $OBJECTS -l$SHARED_LIB$ARCH$VARIANT
}

########### BUILD ####################:
#
#write_newline and error_exit contain data, which should be PIC in order to be included in a 64bit-*.so
# thus we don't put them into it.
#
#for more information read: https://www.technovelty.org/c/position-independent-code-and-x86-64-libraries.html
#
#shared_lib:
echo "building shared library..."
FILES_SHARED="write_record count_chars read_record"
build_sharedlib "$FILES_SHARED"
    
#write_records:
echo "building target <write_records>..."
FILES_WRITE="write_records"
build_target write_records "$FILES_WRITE"

#read_records:
echo "building target <read_records>..."
FILES_READ="read_records write_newline "
build_target read_records "$FILES_READ"

#add_year:
echo "building target <add_year>..."
FILES_YEAR="add_year"
build_target add_year "$FILES_YEAR"

#add_year_error_handled:
echo "building target <add_year_error_handled>..."
FILES_YEAR_WITH_ERROR="add_year_error_handled  write_newline error_exit"
build_target add_year_error_handled "$FILES_YEAR_WITH_ERROR"


