#! /bin/sh

dir=$1;

(gtar c $dir/ && touch /tmp/tar.$$ ) | (bzip2 >$dir.tar.bz2  && touch /tmp/bzip2.$$ )
[ -f /tmp/tar.$$ ] && [ -f /tmp/bzip2.$$ ] && { rm -rf $dir/; true; } || rm -f $dir.tar.bz2

rm -f /tmp/tar.$$ /tmp/bzip2.$$
