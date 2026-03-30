#!/bin/bash

PID=$(pgrep -x wofi)

if [ -z "$PID" ]; then
    exit 0
fi

CPU1=$(ps -p $PID -o %cpu=)
sleep 1
CPU2=$(ps -p $PID -o %cpu=)

if [ "$CPU1" = "$CPU2" ]; then
    kill -9 $PID
fi
