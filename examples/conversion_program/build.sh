########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}
VARIANT=$2
DIR="conversion_program"

#first parameter - target
#second parameter - source files
build_target(){
    if [ $ARCH = "32" ] ; then
        LD_FLAG="-melf_i386"
    else
        LD_FLAG="-melf_x86_64"
    fi
    TARGET="$DIR/$1$ARCH$VARIANT"
    OBJECTS=""
    for name in $2 
    do
         SRC="$name$ARCH$VARIANT.s"
         base=$(basename $name)
         OBJ="$DIR/$base$ARCH$VARIANT.o"
         OBJECTS="$OBJECTS $OBJ"
         as -Iincludes -Irecords --$ARCH  $SRC -o $OBJ
    done
    ld $LD_FLAG $OBJECTS -o $TARGET
}

########### BUILD ####################:

    


#write_records:
echo "building target <conversion_program>..."
FILES_CONVERSION="conversion_program/conversion_program conversion_program/integer2string records/write_newline records/count_chars"
build_target conversion_program "$FILES_CONVERSION"


