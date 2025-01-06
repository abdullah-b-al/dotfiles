#!/usr/bin/env bash

declare -A site

site[odin]="https://pkg.odin-lang.org/ https://odin-lang.org/docs/overview/"
site[zig13]="https://ziglang.org/documentation/0.13.0/std/ https://ziglang.org/documentation/0.13.0/"
site[raylib]="https://www.raylib.com/cheatsheet/cheatsheet.html"

key="$(for v in "${!site[@]}"; do echo $v; done | rofi -dmenu)"

[ -z "$key" ] && exit 1
[ -z "${site[$key]}" ] && exit 1

firefox --class="docs" ${site[$key]} # don't quote to separate all URLs 

exit 0
