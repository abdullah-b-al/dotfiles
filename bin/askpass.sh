#!/bin/sh
parent_id="$(ps -o ppid= $PPID)"
title="$(ps -o args= $parent_id | cut -f 2 | xargs -I {} basename {})"
zenity --password --title="$title"
