#!/bin/sh
set -e

fn="$1".tar.gz
tar acf "$fn" "$1"

cp -r "$fn" "$2"

rm -rf "$fn"
