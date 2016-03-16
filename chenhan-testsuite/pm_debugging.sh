#!/bin/bash

for i in {1..30}
do
    echo "starting $i th suspend"
    echo core >/sys/power/pm_test
    echo platform >/sys/power/disk
    rtcwake -s 10 -m mem
    sleep 10
done

