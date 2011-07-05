#!/bin/sh

export GNU_PORT="$GNUS_GNUSERV_PORT";
if [ -z "$GNU_PORT" ]; then
    echo "$0: Warning: \$GNUS_GNUSERV_PORT not set. Using default port (30000+uid) for communicating with gnuserv" >&2;
    export GNU_PORT=$[ 30000 + $UID ];
fi

if gnuclient -h localhost -batch -eval 'nil' >/dev/null 2>&1; then
    # Gnus is already running in an Emacs instance
    # If an email address was given on the cmd line,
    # pass it to the running Gnus
    # else do nothing
    if [ "$1" ]; then
	gnuclient -h localhost -eval "(mygnus-mail-to \"$1\" \"$2\")";
    else
	gnuclient -h localhost -eval '(progn (switch-to-buffer "*Group*") (delete-other-windows))';
    fi
else
    # Gnus isn't running yet, start it (along with its Emacs instance)
    echo "starting new gnus...";
    if [ "$1" ]; then
	exec xemacs -eval "(gnus) (mygnus-mail-to \"$1\" \"$2\")";
    else
	exec xemacs -eval "(gnus)";
    fi
fi

