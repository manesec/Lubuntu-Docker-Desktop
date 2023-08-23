#! /bin/bash


echo "[*] Setting up vscode ..."
mkdir -p /tmp/code
cd /tmp/code
wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O code.deb
dpkg -i code.deb
cd /tmp
rm -rf /tmp/code
