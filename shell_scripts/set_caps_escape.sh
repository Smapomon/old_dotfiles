#!/bin/bash

before_sleep=$(date +"%T")
echo "keyboard plugged in: ${before_sleep}" >> /home/smapo/shell_scripts/shell_logs.log
setxkbmap -option caps:escape

