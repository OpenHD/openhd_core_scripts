#!/bin/bash

/usr/local/bin/x20/runcam_v2/get_cam_i2c.sh
CAM=$?
echo "Using cam $CAM"

BUS=0

if [ $1 -eq 3 ]; then
	i2cset -y $BUS $CAM 0x12 0x00 0x03 0xA4 0x18 0x1c 0x24 0x28  i
elif [ $1 -eq 5 ]; then
	i2cset -y $BUS $CAM 0x12 0x00 0x03 0xA4 0x24 0x28 0x2c 0x30 i
elif [ $1 -eq 7 ]; then
	i2cset -y $BUS $CAM 0x12 0x00 0x03 0xA4 0x28 0x2B 0x2f 0x32 i
else
	echo "Valid values of saturation are: 3, 5, or 7"
fi

