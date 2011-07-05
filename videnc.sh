#!/bin/bash

audioreset;

mencoder\
 -tv on:driver=v4l:width=768:height=576:adevice=/dev/dsp0 -ovc lavc\
 -lavcopts vcodec=mpeg4:vbitrate=1800\
 -oac mp3lame -lameopts cbr:br=128:vol=1 -vop pp=tn/lb,crop=720:544:24:16\
 -o "$1"


# moeglichkeiten: 
#
#              Audio:
#                 -lameopts ...:vol=[0..10]  -- audio "input gain" für lame.
#                                              Default: ?
#                 -tv ....:volume=[0..65535] -- Audiolautstaerke des v4l-Devices (TV-Karte).
#                                               Default: 65535
#                 extern: "igain"-Einstellung der Soundkarte
