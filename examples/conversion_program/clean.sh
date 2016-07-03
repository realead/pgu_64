########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}

########### BUILD ####################:
  
DIR=conversion_program
 
rm $DIR/*.o

TARGETS="conversion_program"

for target in $TARGETS
do
    rm "$DIR/$target$ARCH$2"
done




