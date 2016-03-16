#!/bin/sh
for index in $(seq 1 100)
do
	xrandr --output HDMI1 --auto --output eDP1 --auto --same-as HDMI1
	sleep 1
	xrandr --output HDMI1 --auto --output eDP1 --off
	sleep 1
	xrandr --output eDP1 --auto --output HDMI1 --auto --right-of eDP1
	sleep 1
	xrandr --output eDP1 --auto --output HDMI1 --off
	sleep 1
	echo 'switch once at' `date` >>date.txt
done

