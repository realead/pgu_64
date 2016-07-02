########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}

########### BUILD ####################:
  
DIR=records
TARGET1="$DIR/write_records$ARCH$2"
TARGET2="$DIR/write_records$ARCH$2"
 
rm records/*.o

TARGETS="write_records read_records"

for target in $TARGETS
do
    rm "$DIR/$target$ARCH$2"
done


