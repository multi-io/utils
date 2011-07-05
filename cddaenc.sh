#! /bin/sh

files="*wav";
if [ "$@" ]; then
  files="$@";
fi

for f in $files; do
    oggenc -b 160 "$f";
    lame -h -b 192 "$f" "`basename "$f" .wav`".mp3;
done
