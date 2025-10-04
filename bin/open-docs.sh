#!/usr/bin/env bash

declare -A site

site[raylib]="https://www.raylib.com/cheatsheet/cheatsheet.html"
site[odin]="https://pkg.odin-lang.org/ https://odin-lang.org/docs/overview/"
site[zig14]="https://ziglang.org/documentation/0.14.0/std/ https://ziglang.org/documentation/0.14.0/"
site[chatgpt]="https://chatgpt.com"


key="$(for v in "${!site[@]}"; do echo $v; done | rofi -dmenu)"

[ -z "$key" ] && exit 1

if [ -z "${site[$key]}" ]; then
    firefox --new-tab "https://search.brave.com/search?q=$key"
else
    if [ $(pgrep firefox) ]; then
        firefox --new-tab ${site[$key]} # don't quote to separate all URLs
    else
        firefox ${site[$key]} # don't quote to separate all URLs
    fi

fi

exit 0
