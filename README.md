# Lubuntu-Docker-Desktop
Run Lubuntu Desktop in Docker container.  XRDP support only !!

![image](img/1.png)

![image](img/2.png)


## Feature
+ Supports XRDP audio output (Patched with pulseaudio-module-xrdp).
+ Using `apt-fast` to speedup apt download.
+ LXQT Desktop Environment.
+ Easy to modify source code.
+ RDP Only.

## How to run ?

``` bash
git clone https://github.com/manesec/Lubuntu-Docker-Desktop.git Lubuntu-Docker-Desktop
cd Lubuntu-Docker-Desktop
docker build -t mylubuntu .
docker run -p 3389:3389 -it --init --cap-add=SYS_ADMIN --shm-size 1g --privileged --rm mylubuntu /bin/RunOnce.sh mane maneisagoodman
```

Note that: 
+ `--cap-add=SYS_ADMIN` and `--shm-size 1g` : used for google-chrome and firefox.
+ `--privileged` To fix nextcloud app error.
+ `mane` is login username.
+ `maneisagoodman` is login password.

X64 working good, I have not test for arm.

## Folder information

When you build a docker image, using `docker build -t mylubuntu .`, it will install some software in `software` folder.

To disable it, just change name without `.sh`, For example:

+ I am not going to install google-chrome: Goto `software`, change `chrome.sh` to `chrome.disable`.


# FAQ

## FAQ: What is the root Password ?

The root password is random, you can check when you start the container.

```bash
root@manepc:/home/mane/Lubuntu-Docker-Desktop# docker run -p 3389:3389 -it --init --cap-add=SYS_ADMIN --privileged --shm-size 1g --rm mylubuntu /bin/RunOnce.sh mane maneisagoodman
...
[*] Random Password
Root Password: 8bfb45234ecf8d11b346
...
```

I am very recommend to use `sudo -s` to get root user.

## FAQ: No sound output?

You may need to run `pulseaudio -D` as root user.

# License 
GNU General Public License v3.0
