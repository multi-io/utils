#! /bin/bash

unpackjar ()
{
    FILE=$1;
    DESTDIR=$2;

    FILEBASE="`basename $FILE`";
    mkdir $DESTDIR/$FILEBASE;
    cp $FILE $DESTDIR/$FILEBASE/$FILEBASE;
    ( cd $DESTDIR/$FILEBASE; jar xf $FILEBASE; )
    rm -f $DESTDIR/$FILEBASE/$FILEBASE;

    for SUBJAR in `find $DESTDIR/$FILEBASE/ -name '*.jar'`; do
        SUBJNAME=`basename $SUBJAR`;
        SUBJDIR=`dirname $SUBJAR`;
        mkdir $SUBJDIR/$SUBJNAME.d
        unpackjar $SUBJAR $SUBJDIR/$SUBJNAME.d;
        rm -f $SUBJDIR/$SUBJNAME;
        mv $SUBJDIR/$SUBJNAME.d/$SUBJNAME $SUBJDIR/;
        rm -rf $SUBJDIR/$SUBJNAME.d;
    done
}

if [ "$#" -ne 2 ]; then
    echo "usage: eardiff file1.ear file2.ear" >&2;
    exit 1;
fi

FILE1=$1;
FILE2=$2;

if [ ! -r $FILE1 ]; then
    echo "can't read $FILE1. Aborting.";
    exit 1;
fi

if [ ! -r $FILE2 ]; then
    echo "can't read $FILE2. Aborting.";
    exit 1;
fi

mkdir $TEMP/eardiff1;
mkdir $TEMP/eardiff2;

unpackjar $FILE1 $TEMP/eardiff1;
unpackjar $FILE2 $TEMP/eardiff2;

FILE1_BASE=`basename $FILE1`;
FILE2_BASE=`basename $FILE2`;

FILE1_XMLS=`cd $TEMP/eardiff1/$FILE1_BASE; find . -name '*.xml'`;
FILE2_XMLS=`cd $TEMP/eardiff2/$FILE2_BASE; find . -name '*.xml'`;

for xmlfile in $FILE1_XMLS; do
    if echo $FILE2_XMLS | grep "$xmlfile" >/dev/null 2>&1; then   # TODO: dieser Test funktioniert nicht korrekt, wenn ein XML-Dateiname aus der einen ear-Datei in einem aus der anderen ear-Datei enthalten ist.
        echo ">>>>>>>>>>>>> diffing $xmlfile in $FILE1_BASE <-> $FILE2_BASE";
        diff -C 3 $TEMP/eardiff1/$FILE1_BASE/$xmlfile $TEMP/eardiff2/$FILE2_BASE/$xmlfile;
    fi
done

rm -rf $TEMP/eardiff1 $TEMP/eardiff2;
