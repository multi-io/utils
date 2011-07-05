#!/bin/sh

if gnuclient -batch -eval 'nil' >/dev/null 2>&1; then
    exec gnuclient "$@";
else
    exec jed "$@";
fi

