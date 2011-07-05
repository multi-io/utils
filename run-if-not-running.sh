#! /bin/sh

PRG=$1
shift

CMDLINE="$@"

if ps -u $UID -eo args | egrep -q "^$PRG"; then
    exit 0;
fi

exec $CMDLINE
