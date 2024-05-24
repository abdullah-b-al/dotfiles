#!/bin/sh
# use opengl for now because egl's GPU usage is way too high
looking-glass-client -m 70 input:rawMouse=yes win:noScreensaver=yes app:renderer=OpenGL $@
