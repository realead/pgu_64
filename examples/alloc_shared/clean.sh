########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}

########### BUILD ####################:
  
DIR=alloc_shared
 
rm $DIR/*.o
rm $DIR/*.so

TARGETS="alloc_shared"

for target in $TARGETS
do
    rm "$DIR/$target$ARCH$2"
done




