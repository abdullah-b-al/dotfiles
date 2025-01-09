#!/usr/bin/env bash

declare -A site

site[odin]="https://pkg.odin-lang.org/ https://odin-lang.org/docs/overview/"
site[zig13]="https://ziglang.org/documentation/0.13.0/std/ https://ziglang.org/documentation/0.13.0/"
site[raylib]="https://www.raylib.com/cheatsheet/cheatsheet.html"

key="$(for v in "${!site[@]}"; do echo $v; done | rofi -dmenu)"

[ -z "$key" ] && exit 1

if [ -z "${site[$key]}" ]; then
    firefox --new-tab --class="docs" "https://search.brave.com/search?q=$key"
else
    if [ $(pgrep firefox) ]; then
        firefox --new-tab --class="docs" ${site[$key]} # don't quote to separate all URLs 
    else
        firefox --class="docs" ${site[$key]} # don't quote to separate all URLs 
    fi

fi

exit 0
