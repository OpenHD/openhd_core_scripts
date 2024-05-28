#!/bin/bash

#initialise x20 air-unit

#add platform identification
systemctl stop openhd
mkdir -p /usr/local/share/openhd_platform/x20
mkdir -p /usr/local/share/openhd_platform/wifi_card_type/88xxau/
touch /usr/local/share/openhd_platform/wifi_card_type/88xxau/custom
touch /usr/local/share/openhd_platform/x20/hdzero

echo 1 >/sys/class/leds/openhd-x20dev\:red\:usr/brightness
echo 0 >/sys/class/leds/openhd-x20dev\:green\:usr/brightness
echo 0 >/sys/class/leds/openhd-x20dev\:blue\:usr/brightness

depmod -a
rmmod 88XXau_ohd
sudo insmod /usr/lib/modules/5.8.0/kernel/drivers/net/88XXau_ohd.ko rtw_amplifier_type_2g=0 rtw_amplifier_type_5g=1 rtw_RFE_type=1 rtw_TxBBSwing_2G=0 rtw_TxBBSwing_5G=3 > /external/load_driver.log

echo 0 >/sys/class/leds/openhd-x20dev\:red\:usr/brightness
echo 0 >/sys/class/leds/openhd-x20dev\:green\:usr/brightness
echo 1 >/sys/class/leds/openhd-x20dev\:blue\:usr/brightness

modprobe HdZero
gst-launch-1.0 -ve v4l2src device=/dev/video0 num-buffers=72 ! video/x-raw,width=1280,height=720,framerate=60/1,format=NV12 ! cedar_h264enc keyint=12 bitrate=16000 !  video/x-h264 ! h264parse ! matroskamux ! filesink location="/home/openhd/$fname" >& /home/openhd/GStreamerLog.txt

systemctl start openhd

echo 0 >/sys/class/leds/openhd-x20dev\:red\:usr/brightness
echo 0 >/sys/class/leds/openhd-x20dev\:green\:usr/brightness
echo 1 >/sys/class/leds/openhd-x20dev\:blue\:usr/brightness