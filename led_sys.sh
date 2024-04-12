#!/bin/bash

TYPE=$1
COLOR=$2
MODIFIER=$3
DEBUG=$4

if [ "$TYPE" == "" ]; then 
echo "OpenHD LED Control"
echo "__________________"
echo "usage:"
echo "led TYPE COLOR DELAY DEBUG"
echo "available types:"
echo "________________"
echo "on|off|manual|warning|error"
fi

#kill all previous instances
pkill -f led_sys.sh

debugMessage() {
    if [ "$DEBUG" == "debug" ]; then
        echo "$1"
    fi
}

# Detect platform and LED-type
if [ -d /sys/class/leds/openhd-x20dev ]; then
    PLATFORM="x20"
    debugMessage "Platform: X20"

elif grep -q "Raspberry Pi" /proc/cpuinfo; then
    PLATFORM="pi"
    debugMessage "Platform: RPI"

    if [ ! -d /sys/class/leds/PWR ]; then
        COLOR="green"
        debugMessage "Only One LED"
    fi
fi

# Main functions
LED_ON() {
    if [ "$PLATFORM" == "x20" ]; then 
        if [ "$COLOR" == "red" ]; then 
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
            debugMessage "Red LED on"
        elif [ "$COLOR" == "green" ]; then
            echo 0 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
            debugMessage "Green LED on"            
        elif [ "$COLOR" == "blue" ]; then
            echo 0 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
            debugMessage "Blue LED on"
        elif [ "$COLOR" == "cyan" ]; then
            echo 0 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
            debugMessage "Cyan LED on"  
        elif [ "$COLOR" == "magenta" ]; then
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
            debugMessage "Magenta LED on"  
        elif [ "$COLOR" == "yellow" ]; then
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 0 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
            debugMessage "Yellow LED on"  
        elif [ "$COLOR" == "white" ]; then
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
            debugMessage "White LED on"  
        else
            #set it to white if no or wrong argument is passed
            echo 1 > /sys/class/leds/openhd-x20dev:red:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:green:usr/brightness
            echo 1 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
            debugMessage "White LED on" 
        fi
    elif [ "$PLATFORM" == "pi" ]; then 
        if [ "$COLOR" == "green" ]; then 
            echo 1 > /sys/class/leds/ACT/brightness
            debugMessage "Green LED on" 
        elif [ "$COLOR" == "red" ]; then
            echo 1 > /sys/class/leds/PWR/brightness
            debugMessage "Red LED on" 
        else 
            echo 1 > /sys/class/leds/ACT/brightness
            echo 1 > /sys/class/leds/PWR/brightness
        fi
    fi
}

LED_OFF() {
    if [ "$PLATFORM" == "x20" ]; then 
        echo 0 > /sys/class/leds/openhd-x20dev:red:usr/brightness
        echo 0 > /sys/class/leds/openhd-x20dev:green:usr/brightness
        echo 0 > /sys/class/leds/openhd-x20dev:blue:usr/brightness
        debugMessage "LEDs off" 
    elif [ "$PLATFORM" == "pi" ]; then
        echo 0 > /sys/class/leds/ACT/brightness
        echo 0 > /sys/class/leds/PWR/brightness
        debugMessage "LEDs off" 
    fi
}

BLINK_LED() {
    while true; do
       LED_ON
       sleep $(echo "$MODIFIER * 0.01" | bc)
       LED_OFF
       sleep $(echo "$MODIFIER * 0.01" | bc)
    done
}
BLINK_LED_ASYNC() {
    while true; do
       LED_ON
       sleep $(echo "$DELAY1 * 0.01" | bc)
       LED_OFF
       sleep $(echo "$DELAY1 * 0.01" | bc)
    done
}

# LED mode Selection
if [ "$TYPE" == "on" ]; then 
    LED_ON
elif [ "$TYPE" == "off" ]; then 
    LED_OFF
elif [ "$TYPE" == "manual" ]; then 
    if [ -z "$MODIFIER" ]; then
        echo "Missing delay value for MANUAL mode."
    else
        BLINK_LED
    fi
elif [ "$TYPE" == "warning" ]; then 
    if [ -z "$MODIFIER" ]; then
        echo "Missing value for Warning mode."
    else
        COLOR="green"
        DELAY1="50"
        DELAY2="200"
        BLINK_LED_ASYNC
        debugMessage "LED Warning $MODIFIER" 
    fi
elif [ "$TYPE" == "error" ]; then 
    if [ -z "$MODIFIER" ]; then
        echo "Missing value for Error mode."
    else
        COLOR="red"
        DELAY1="50"
        DELAY2="200"
        BLINK_LED_ASYNC
        debugMessage "LED Warning $MODIFIER" 
    fi
fi
