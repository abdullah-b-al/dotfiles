#!/bin/sh

current_profile_file="/tmp/screen-settings-current-profile"
profile="$1"
force=false
[ -z "$profile" ] && profile="normal"
[ "$2" = "force" ] && force=true

brightness="15"
if [ "$profile" = "gaming" ]; then
    brightness="100"
    gammastep_kill="0"
fi

while [ "$(pgrep ddcutil)" ]; do
    sleep 0.5
done

current_profile=""
if [ -f "$current_profile_file" ]; then
    current_profile="$(cat "$current_profile_file")"
fi

if [ "$current_profile" = "$profile" ] && [ "$force" = false ]; then
    echo exiting
    exit
fi

echo "$profile" > "$current_profile_file"

sudo ddcutil --display 2 setvcp 10 $brightness
# [ -n $gammastep_kill ] && pkill gammastep
# [ -z $gammastep_kill ] && gammastep &
notify-send -t 2000 "Screen profile: $profile"
