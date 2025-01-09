#!/bin/sh
parent_id="$(ps -o ppid= $PPID)"
proc="$(ps -o args= $parent_id | cut -f 2 | xargs -I {} basename {})"
command="$(ps -o args= $PPID | cut -f 2 | xargs -I {} basename {})"
hint="$proc"
[ -z "$hint" ] && hint="$command"
# zenity --password --title="$hint"
rofi -dmenu \
    -theme-str "window { y-offset: 5;border: 1px solid; location: center; width: 33%; height: 100px;}" \
	-password \
	-no-fixed-num-lines \
    -p "Password for $hint:"
