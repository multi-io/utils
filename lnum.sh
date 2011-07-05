#! /bin/bash

IFS=`printf '\n'`

if [ $# == 1 ]; then
    width=$1;
else
    width=3;
fi

num=1;

while read line; do
    printf "%${width}i: " $num;
    echo $line;
    num=$[ $num + 1 ];
done
