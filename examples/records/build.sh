########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}
VARIANT=$2
DIR="records"

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
         as -I records --$ARCH  $SRC -o $OBJ
    done
    ld $LD_FLAG $OBJECTS -o $TARGET
}

########### BUILD ####################:

    


#write_records:
echo "building target <write_records>..."
FILES_WRITE="write_record write_records"
build_target write_records "$FILES_WRITE"

#read_records:
echo "building target <read_records>..."
FILES_READ="count_chars read_record write_newline read_records"
build_target read_records "$FILES_READ"

#add_year:
echo "building target <add_year>..."
FILES_YEAR="add_year read_record write_record"
build_target add_year "$FILES_YEAR"



