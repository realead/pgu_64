#all run.sh-scripts must be called with the following options:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

cd alloc_shared

ARCH=${1:-"64"}

EXE="./alloc_shared$ARCH$2"

echo "Watch out for debug info of malloc and free..."
LD_PRELOAD=./libmyalloc$ARCH$2.so $EXE


echo "$EXE run and returned: $?"

cd ..


