#!/bin/bash

# OpenHD utility to write images to internal flash
# Works on Radxa boards only
# X20, CM3, Zero3W(E), CM5, Rock5A Rock5B

DEBUG=$1


debugMessage() {
    if [ "$DEBUG" == "debug" ]; then
        [ -d /boot/openhd ] || mkdir -p /boot/openhd && touch /boot/openhd/flash.log
        echo "$(date '+%Y-%m-%d %H:%M:%S') $1" 
        echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> /boot/openhd/flash.log
    fi
}

led() {
    led_sys.sh "$@"
}

# Detect platform
if [ -d /sys/class/leds/openhd-x20dev ]; then
    PLATFORM="x20"
    debugMessage "Platform: X20"
elif [ ! -d /sys/class/leds/user-led/brightness ]; then
    PLATFORM="cm3"
    debugMessage "Platform: CM3"
elif [ ! -d /sys/class/leds/board-led ]; then
    PLATFORM="zero3"
    debugMessage "Platform: Zero3"
fi

# Detect which partition is currently used
PARTITION=$(df -h / | awk 'NR==2 {print $1}')
CARD=$(df --output=source / | tail -n 1 | cut -d'p' -f1)
if [ "$CARD" == "/dev/mmcblk0" ]; then
    TARGET="/dev/mmcblk1"
elif [ "$CARD" == "/dev/mmcblk1" ]; then
    TARGET="/dev/mmcblk0"
else 
    exit 1
fi

# Debug output
debugMessage "____ Platform: $PLATFORM ____"
debugMessage "____ Partition: $PARTITION ____"
debugMessage "____ Memory Card: $CARD ____"
debugMessage "____ Target: $TARGET ____"

# Set window/text color
export NEWT_COLORS='
root=,black
window=black,black
border=black,black
textbox=white,black
button=white,black
emptyscale=,black
fullscale=,white
'

# Main Function of this script 
led off
led manual all 2 &
if [ -d /opt/additionalFiles/emmc.img ]; then
    (pv -n /opt/additionalFiles/emmc.img | dd of=$TARGET bs=128M conv=notrunc,noerror) 2>&1 | whiptail --gauge "Flashing OpenHD to EMMC, please wait..." 10 70 0
else
    debugMessage "failed"
    led off
    led on
fi
mkdir -p /media/new
mount "$TARGET"p1 /media/new
cp -r /boot/openhd/* /media/new/openhd/
whiptail --msgbox "Please reboot your system now" 10 40
led off
exit 0
