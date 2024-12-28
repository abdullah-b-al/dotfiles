#!/bin/sh
parent_id="$(ps -o ppid= $PPID)"
proc="$(ps -o args= $parent_id | cut -f 2 | xargs -I {} basename {})"
command="$(ps -o args= $PPID | cut -f 2 | xargs -I {} basename {})"
hint="$proc"
[ -z "$hint" ] && hint="$command"
# zenity --password --title="$title"
rofi -dmenu \
    -theme-str "window { y-offset: -1;border: 1px solid; }" \
	-password \
	-no-fixed-num-lines \
    -p "Password for $hint:"
