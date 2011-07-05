#!/bin/bash

SRCDIR=mydir
#FILES=`eval echo "$SRCDIR/$1"`;
FILES="$SRCDIR/$1";

echo FILES=$FILES;

cp $FILES some_other_dir;
