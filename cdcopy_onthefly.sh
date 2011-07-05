#! /bin/bash

#cdrdao copy --source-device /dev/cdcopy-src --device /dev/cdcopy-dest --driver generic-mmc-raw --speed 20 --source-driver generic-mmc-raw --on-the-fly

cdrdao copy --source-device /dev/cdcopy-src --device /dev/cdcopy-dest --driver generic-mmc --source-driver generic-mmc --on-the-fly
