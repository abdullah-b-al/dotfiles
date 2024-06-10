#!/bin/sh
log="/tmp/looking-glass-log"
echo "\n================================================================================\n" >> "$log"
# use opengl for now because egl's GPU usage is way too high
looking-glass-client -m 70 input:rawMouse=yes win:noScreensaver=yes app:renderer=OpenGL $@ 2>> "$log"
