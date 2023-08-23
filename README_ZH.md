# Lubuntu-Docker-桌面
在 Docker 容器内運行 Lubuntu Desktop，注意: 僅支持 XRDP！

![圖片](img/1.png)

![圖片](img/2.png)


## 功能
+ 支持 XRDP 音頻輸出（用pulseaudio-module-xrdp 修補）。
+ 使用 `apt-fast` 來加速 apt 下載。
+ LXQT 桌面環境，簡單輕量。
+ 易於修改源代碼。
+ 僅RDP協議。

## 如何運行？

```bash
git clone https://github.com/manesec/Lubuntu-Docker-Desktop.git Lubuntu-Docker-Desktop
cd Lubuntu-Docker-Desktop
docker build -t mylubuntu .
docker run -p 3389:3389 -it --init --cap-add=SYS_ADMIN --shm-size 1g --privileged --rm mylubuntu /bin/RunOnce.sh mane maneisagoodman
````

注意：
+ `--cap-add=SYS_ADMIN` 和 `--shm-size 1g` ：用於 google-chrome 和 firefox，不然很容易崩溃。
+ `--privileged` 修復 nextcloud 應用程序錯誤，為了安全可以去掉這行。
+ `mane` 是登錄用戶名,隨意修改。
+ `maneisagoodman` 是登錄密碼,隨意修改。

X64運行良好，arm不工作。

## `software` 文件夾

當您使用`docker build -t mylubuntu .` 構建 docker 映像時，它將在 `software` 文件夾里執行所有.sh 文件。

要禁用它，只需更改不帶`.sh`的名稱，例如：

+ 我不打算安裝 google-chrome：把，將 `software` 文件夾里的 `chrome.sh` 更改為`chrome.disable` 就可以了。


＃ 常問問題

## 常見問題：root 密碼是什麼？

root密碼是隨機的，啟動容器時可以查看。

````bash
root@manepc:/home/mane/Lubuntu-Docker-Desktop# docker run -p 3389:3389 -it --init --cap-add=SYS_ADMIN --privileged --shm-size 1g --rm mylubuntu /bin/ RunOnce.sh mane maneisagoodman
...
[*] 隨機密碼
根密碼：8bfb45234ecf8d11b346
...
````

我強烈建議使用 `sudo -s` 來使用 root 用戶。

## 常見問題：沒有聲音輸出？

您可能需要以 root 用戶身份運行 `pulseaudio -D`。

＃ 執照
GNU 通用公共許可證 v3.0
