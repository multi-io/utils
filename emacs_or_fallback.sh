#!/bin/sh

if gnuclient -h localhost -batch -eval 'nil' >/dev/null 2>&1; then
    exec gnuclient -h localhost "$@";
else
    if emacsclient --eval 'nil' >/dev/null 2>&1; then
        exec emacsclient "$@";
    else
        exec vim "$@";
    fi
fi
