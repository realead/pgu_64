#all run.sh-scripts must be called with the following options:
# $1 directory
# $2 executable

DIR=$1
EXE=$2

SRC=$DIR"/text.small"
DEST=$DIR"/text.upper"
 
$EXE $SRC $DEST

echo "$EXE run and returned: $?"

echo "source:"
more $SRC 

echo "result:"
more $DEST

rm $DEST

