#!/bin/bash

# OpenHD untility to write images to internal flash
# Works on Radxa boards only
# X20, CM3, Zero3W(E), CM5, Rock5A Rock5B

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
    debugMessage "Platform: X20"
elif [ ! -d /sys/class/leds//board-led ]; then
    PLATFORM="zero3"
    debugMessage "Platform: zero3"
fi

# Detect which partition is currently used
PARTITION=$(df -h / | awk 'NR==2 {print $1}')
CARD=$(df --output=source / | tail -n 1 | cut -d'p' -f1)

# Debug output
DEBUG="debug"
debugMessage "____ Platform: $PLATFORM ____"
debugMessage "____ Partition: $PARTITION ____"
debugMessage "____ Memory Card: $CARD ____"

# Main Function of this script 
led off
led manual all 2 &
    #  -e '\nexport NEWT_COLORS='\''\nroot=,black\nwindow=black,black\nborder=black,black\ntextbox=white,black\nbutton=white,black\nemptyscale=,black\nfullscale=,white\n'\'' \\\n\n(pv -n /opt/additionalFiles/emmc.img | dd of=/dev/mmcblk0 bs=128M conv=notrunc,noerror) 2>&1 | whiptail --gauge "Flashing OpenHD to EMMC, please wait..." 10 70 0\necho "please reboot or powerdown the system now"' >> /root/.bashrc
echo "debug"
mkdir -p /media/new
mount /dev/mmcblk0p1 /media/new
cp -r /boot/openhd/* /media/new/openhd/
whiptail --msgbox "Please reboot your system now" 10 40
led off
