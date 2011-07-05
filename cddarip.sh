#!/bin/sh

if [ -z "$*" ]; then
    nTracks=25;
    echo "no. of tracks not given on cmdline, assuming $nTracks\n";
else
    nTracks=$1;
fi

for i in `seq -w 1 $nTracks`; do
    cdda2wav -t "$i+$i" "track-$i.wav";
done
