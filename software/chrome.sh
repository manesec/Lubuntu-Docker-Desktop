#! /bin/bash


echo "[*] Setting up google chrome ..."
mkdir -p /tmp/chrome
cd /tmp/chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
dpkg -i chrome.deb
cd /tmp
rm -rf /tmp/chrome
