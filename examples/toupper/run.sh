#all run.sh-scripts must be called with the following options:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

########## ANALISE OPTIONS ###############:
ARCH=${1:-"64"}

EXE="toupper/toupper$ARCH$2"


SRC="toupper/text.small"
DEST="toupper/text.upper"
 
$EXE $SRC $DEST

echo "$EXE run and returned: $?"

echo "source:"
more $SRC 

echo "result:"
more $DEST

rm $DEST

