#all run.sh-scripts must be called with the following options:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')


cd alloc

ARCH=${1:-"64"}


#run write records:
EXE="./copyfile$ARCH$2"

$EXE orig.txt copy.txt

echo "$EXE run and returned: $?"

echo "Original content:"
more orig.txt
echo "Copied content:"
more copy.txt

rm copy.txt

cd ..


