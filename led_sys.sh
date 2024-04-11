#!/bin/bash

TYPE=$1
MODIFIER=$2
COLOR=$3

# Detect platform and LED-type
if [ -d /sys/class/leds/openhd-x20dev ]; then
    PLATFORM="x20"
    echo "x20"
elif grep -q "Raspberry Pi" /proc/cpuinfo; then
    PLATFORM="pi"
    echo "pi"
fi

# Main functions
LED_ON() {
    echo "led"
    if [ "$PLATFORM" == "x20" ]; then 
        if [ "$1" == "red" ]; then 
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
        elif [ "$1" == "green" ]; then
            echo 0 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
        elif [ "$1" == "blue" ]; then
            echo 0 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
        elif [ "$1" == "cyan" ]; then
            echo 0 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
        elif [ "$1" == "magenta" ]; then
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
        elif [ "$1" == "yellow" ]; then
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
        elif [ "$1" == "white" ]; then
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
        else
            #set it to white if no or wrong argument is passed
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
        fi
    elif [ "$PLATFORM" == "pi" ]; then 
    echo "led pi"
        if [ "$1" == "green" ]; then 
            echo 1 > /sys/class/leds/ACT/brightness
            echo "green"
        elif [ "$1" == "red" ]; then
            echo 1 > /sys/class/leds/PWR/brightness
            echo "red"
        fi
    fi
}

LED_OFF() {
    if [ "$PLATFORM" == "x20" ]; then 
        echo 0 > /sys/class/leds/openhd-x20dev:red:usr/brightness
        echo 0 > /sys/class/leds/openhd-x20dev:green:usr/brightness
        echo 0 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
    elif [ "$PLATFORM" == "pi" ]; then
        echo 0 > /sys/class/leds/ACT/brightness
        echo 0 > /sys/class/leds/PWR/brightness
    fi
}

# LED mode Selection
if [ "$TYPE" == "on" ]; then 
    LED_ON "$COLOR"
elif [ "$TYPE" == "off" ]; then 
    LED_OFF
elif [ "$TYPE" == "manual" ]; then 
    if [ -z "$MODIFIER" ]; then
        echo "Missing delay value for MANUAL mode."
    else
        echo "Flash LED with $MODIFIER delay"
    fi
elif [ "$TYPE" == "warning" ]; then 
    if [ -z "$MODIFIER" ]; then
        echo "Missing value for Warning mode."
    else
        echo "LED Warning $MODIFIER"
    fi
elif [ "$TYPE" == "error" ]; then 
    if [ -z "$MODIFIER" ]; then
        echo "Missing value for Error mode."
    else
        echo "LED Error $MODIFIER"
    fi
else
    echo "Unknown LED control type: $TYPE"
fi
