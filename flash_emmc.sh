#!/bin/bash

# OpenHD untility to write images to internal flash
# Works on Radxa boards only
# X20, CM3, Zero3W(E), CM5, Rock5A Rock5B

debugMessage() {
    if [ "$DEBUG" == "debug" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> /boot/openhd/flash.log
    fi
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
CARD=$(df -h / | awk 'NR==2 {gsub(/[0-9]+p/, "", $1); print $1}')


# Main Function of this script 
echo "____Platform____"
echo $PLATFORM
echo "____Partition____"
echo $PARTITION
echo "____Memory Card____"
echo $CARD