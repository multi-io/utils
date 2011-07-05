#! /bin/bash

if [ -z "$1" ]; then
  echo "usage: disk2file <file>" >&2
  echo " => copy contents  of 1.44k floppy at /dev/fd0 to <file>" >&2
  exit 1
fi

dd bs=1k count=1423 if=/dev/fd0 of=$1
