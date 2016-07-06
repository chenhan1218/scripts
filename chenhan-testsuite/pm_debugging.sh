#!/bin/bash

# Suspend the system without give control to bios
# Ref doc: https://www.kernel.org/doc/Documentation/power/basic-pm-debugging.txt
#
# core
# - test the freezing of processes, suspending of devices, platform global
#   control methods(*), the disabling of nonboot CPUs and suspending of
#   platform/system devices
#
# Ref doc: https://01.org/blogs/rzhang/2015/best-practice-debug-linux-suspend/hibernate-issues

for i in {1..30}
do
    echo "starting $i th suspend"
    echo core >/sys/power/pm_test
    echo platform >/sys/power/disk
    rtcwake -s 10 -m mem
    sleep 10
done

