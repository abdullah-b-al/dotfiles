set -e

bookmarks="$HOME/personal/bookmarks"

url="$(grep -ve "^http" -ve "^\s*$" $bookmarks | rofi -dmenu -matching fuzzy -i | xargs -I {} grep -A 2 {} "$bookmarks" | sed -n "2 p")"

[ -z "$url" ] && exit 1

"$BROWSER" "$url"
