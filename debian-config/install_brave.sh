#!/bin/sh
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
channel="deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"
echo $channel | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo nala update
sudo nala install --assume-yes brave-browser
