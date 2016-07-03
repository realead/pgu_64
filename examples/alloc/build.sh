########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}
VARIANT=$2
DIR="alloc"

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
         SRC="$DIR/$name$ARCH$VARIANT.s"
         OBJ="$DIR/$name$ARCH$VARIANT.o"
         OBJECTS="$OBJECTS $OBJ"
         as -Iincludes --$ARCH  $SRC -o $OBJ
    done
    ld $LD_FLAG $OBJECTS -o $TARGET
}

########### BUILD ####################:

    


#write_records:
echo "building target <copyfile>..."
FILES_COPY="copyfile alloc"
build_target copyfile "$FILES_COPY"



