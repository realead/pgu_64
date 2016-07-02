#all run.sh-scripts must be called with the following options:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')


cd records

ARCH=${1:-"64"}

EXE="./write_records$ARCH$2"

$EXE

echo "$EXE run and returned: $?"

echo "test.dat has the following content (only strings):"
more test.dat

rm test.dat

cd ..


