#!/bin/sh

name="myenv"
name_tar="$name.tar"
out_dir="zig-out/bin"
out_bin="$out_dir/$name"
out_tar="$out_dir/$name_tar"
myenv_dir="$DOTFILES/myenv"

start_dir="$(pwd)"

build() {
  notify-send "myenv.sh" "Building..."
  zig build || exit 1
  make_tar
}

make_tar() {
  tar --create src > "$out_tar"
}

files_changed() {
  tar --create src | cmp --silent "$out_tar" -
  test "$?" != 0
}

cd "$myenv_dir" || exit 1

! [ -e "$out_bin" ] && build
! [ -e "$out_tar" ] && make_tar
files_changed && build

cd "$start_dir" || exit 1

"$myenv_dir/$out_bin" "$@"
