#! /bin/bash

seconds=$1
shift

"$@" &

sleep $seconds

kill -INT $?
