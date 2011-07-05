#! /bin/bash

if [ -z "$1" ]; then
  echo "usage: file2disk <file>" >&2
  echo " => copy <file> to 1.44k floppy at /dev/fd0" >&2
  exit 1
fi

dd bs=1k count=1423 if=$1 of=/dev/fd0
