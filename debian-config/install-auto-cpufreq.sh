#!/bin/sh
[ "$1" != "force" ] && command -v auto-cpufreq && echo Already installed && exit 0

git clone https://github.com/AdnanHodzic/auto-cpufreq.git /tmp/auto-cpufreq
cd /tmp/auto-cpufreq
sudo ./auto-cpufreq-installer --install
sudo auto-cpufreq --install

rm -rf /tmp/auto-cpufreq
