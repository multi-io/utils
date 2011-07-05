#! /bin/sh

rpmdir=/tmp/rpmdir

tmpdir=/tmp/unpacksrcrpm.$$
mkdir -p $tmpdir

(rpm2cpio $1 && touch $tmpdir/rpm2cpio.$$) | (cd $tmpdir && cpio -id && touch $tmpdir/cpio.$$)

( [ ! -f $tmpdir/rpm2cpio.$$ ] || [ ! -f $tmpdir/cpio.$$ ] ) && { rm -rf $tmpdir; exit 1; }

rm -f $tmpdir/rpm2cpio.$$ $tmpdir/cpio.$$

cd $tmpdir

cp -i `find . -type f -name '*.spec'` $rpmdir/SPECS/
cp -i `find . -type f ! -name '*.spec'` $rpmdir/SOURCES/

cd ..
rm -rf $tmpdir
