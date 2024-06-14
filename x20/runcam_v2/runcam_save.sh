#!/bin/bash

/usr/local/bin/x20/runcam_v2/get_cam_i2c.sh
CAM=$?
BUS=0

#save settings
i2cset -y $BUS $CAM 0x12 0x00 0x06 0x94 0x00 0x00 0x03 0x10 i
i2cset -y $BUS $CAM 0x12 0x00 0x06 0x94 0x00 0x00 0x03 0x11 i

