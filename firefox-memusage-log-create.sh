#!/bin/sh

while true; do ps -ao user,rss,size,vsz,args | grep "$USER" | grep /usr/lib/firefox/firefox-bin | grep -v grep | awk '{print systime() " " $2 " " $4}'; sleep 60; done >>firefox-memusage-log.txt

