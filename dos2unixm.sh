#! /bin/bash


for f in "$@"; do
  dos2unix $f >$f.new;
  mv $f.new $f
done
