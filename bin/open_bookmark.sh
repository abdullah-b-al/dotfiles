set -e

bookmarks="$HOME/personal/bookmarks"

url="$(grep -ve "^http" -ve "^\s*$" $bookmarks | rofi -dmenu | xargs -I {} grep -A 2 {} "$bookmarks" | sed -n "2 p")"

$BROWSER $url
