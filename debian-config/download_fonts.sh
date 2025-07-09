#!/usr/bin/env bash

temp="/tmp/fonts"

mkdir -p "$HOME/.local/share/fonts"
mkdir -p "$temp"
cd "$dir"

set \
    "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/UbuntuMono.zip"

for font in "$@"
do
    file="$(basename $font)"
    wget --no-config -O $file "$font"
    unzip -d $temp $file
    mv --force $temp/*.ttf $HOME/.local/share/fonts
    mv --force $temp/fonts/ttf/*.ttf $HOME/.local/share/fonts
done

fc-cache -fv
rm -rf $temp
