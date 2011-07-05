#! /bin/bash

free="`df /tmp | tail -1 | awk '{print $4}'`";

if [ "$free" -lt 750000 ]; then
    echo "not enough space on /tmp (nedd at least 750000 K)";
    exit -1;
fi

cd /tmp &&
cdrdao copy --source-device /dev/cdcopy-src --device /dev/cdcopy-dest --driver generic-mmc  --source-driver generic-mmc --speed 4
