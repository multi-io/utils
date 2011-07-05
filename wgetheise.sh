#! /bin/sh

start=$1
end=$2

echo "getting articles from $start to $end (both inclusive)"

for i in `seq $start $end`; do
    wget -O "article$i.html" "http://www.heise.de/newsticker/forum/go.shtml?read=1&msg=$i&g=20010902sha000";
done

gtar czf /home/oklischa/.public_html/heise.tgz article*.html

