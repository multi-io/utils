#!/bin/sh

ps ax | grep pppd | grep -v grep | grep -v pppoe | grep notty | awk '{print $1}' | xargs kill

