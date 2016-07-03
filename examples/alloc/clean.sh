########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}

########### BUILD ####################:
  
DIR=alloc
 
rm $DIR/*.o

TARGETS="copyfile"

for target in $TARGETS
do
    rm "$DIR/$target$ARCH$2"
done


