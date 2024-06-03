#!/bin/sh

if setxkbmap -query | grep -q "^layout:.*us$"; then
    setxkbmap -layout 'ara'
else
    setxkbmap -layout 'us'
fi
