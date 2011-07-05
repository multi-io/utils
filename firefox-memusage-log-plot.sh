#!/bin/sh

cat firefox-memusage-log.txt | awk "{print \$1-`head -1 firefox-memusage-log.txt | awk '{print $1}'` \" \" \$2 \" \" \$3}" | xy+-plot | gnuplot-and-wait

