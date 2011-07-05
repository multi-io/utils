#!/bin/bash

[ -z "`pidof xmms`" ] && { xmms & sleep 2; }

[ -n "$*" ] && xmms "$@";
