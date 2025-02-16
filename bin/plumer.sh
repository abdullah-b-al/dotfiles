#!/bin/sh

full_string="$(xsel --output --clipboard)"
# I don't know why but xsel outputs the string in reverse lines, so I use tail
string="$(echo "$full_string" | tail -n 1 | awk '{ print substr( $0, 0, 80 ) }')"

prompt="What to do with "
if [ "$full_string" = "$string" ]; then
    prompt="$prompt \`$string\`"
else
    prompt="$prompt \`$string...\`"
fi

operation="$(rofi -p "$prompt" -dmenu <<EOF
bookmark
open
EOF
)"

case "$operation" in
    *open*)
        open.sh "$string"
        ;;
    *bookmark*)
        bookmarks.sh put "$string"
        ;;
esac
