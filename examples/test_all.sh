#!/bin/sh

# run "sh test_all.sh" or  "sh test_all.sh 64"  for building, running and cleaning  all examples in 64 bit mode
# run "sh test_all.sh 32"  for building, running and cleaning all examples in 32 bit mode

########## ANALISE OPTIONS ###############:
# $1 - architecture (optional, default 64)
# $2 - variant (optional, default '')

ALL="exit maximum power factorial toupper records hello_world_nolib hello_world_lib printf_example"

for test_case in $ALL
do
    echo "\n\n##### TESTING $test_case ##########"
    sh build_and_run.sh $test_case $1 $2
    echo "######### DONE TESTING $test_case #########\n\n"
done



