#!/bin/sh

ed="$EDITOR" || vi;
[ -x "`which $ed`" ] || { echo "no such executable: $ed. Using vi." >&2; ed=vi; }

"$ed" "$@"
