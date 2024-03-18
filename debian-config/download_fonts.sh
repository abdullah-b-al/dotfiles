set -e

mkdir -p $HOME/.local/share/fonts
mkdir -p /tmp/fonts

dir="/tmp/fonts"
file="$dir/UbuntuMono.zip"

wget --no-config -O $file "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/UbuntuMono.zip"
unzip -d $dir $file
mv $dir/*.ttf $HOME/.local/share/fonts

fc-cache -fv
rm -rf $dir
