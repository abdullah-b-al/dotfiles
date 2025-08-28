#!/bin/sh

[ -z "$1" ] && exit

project_name="$(basename $1)"
notes="$HOME/personal/notes/$project_name.md"
! [ -e "$notes" ] && {
    notify-send "$notes doesn't exists";
    exit 1;
}
editor.sh "$notes"
