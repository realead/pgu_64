########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ARCH=${1:-"64"}

########### BUILD ####################:
  

TARGET="records/write_records$ARCH"
 
rm records/*.o
rm $TARGET


