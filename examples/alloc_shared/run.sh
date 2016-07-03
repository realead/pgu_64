#all run.sh-scripts must be called with the following options:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

cd alloc_shared

ARCH=${1:-"64"}

EXE="./alloc_shared$ARCH$2"

LD_PRELOAD=./libmyalloc$ARCH$2.so $EXE


cd ..


