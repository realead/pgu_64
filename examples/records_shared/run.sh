#all run.sh-scripts must be called with the following options:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

cd records_shared
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.

ARCH=${1:-"64"}


#run write records:
EXE="./write_records$ARCH$2"

$EXE

echo "$EXE run and returned: $?"

DATA="test.dat"
echo "$DATA has the following content (only strings):"
more $DATA


#run read_records:
echo "The names are (should be Fredrick, Marilyn, Derrick):"
EXE="./read_records$ARCH$2"
$EXE

echo "$EXE run and returned: $?"


#run add_year
EXE="./add_year$ARCH$2"
$EXE

echo "$EXE run and returned: $?"
DATA="testout.dat"
echo "$DATA has the following content (only strings):"
more $DATA


#delete temps
rm test.dat
rm testout.dat

#run add_year_error_handled

EXE="./add_year_error_handled$ARCH$2"
echo "$EXE should exit gracefully with an error message:"
$EXE
echo "$EXE run and returned: $?"

if [ -e testout.dat ] ; then
    echo "Error! testout.dat should not exist but does!"
fi

cd ..


