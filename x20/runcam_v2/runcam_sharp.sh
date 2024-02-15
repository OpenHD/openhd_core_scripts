
CAM=0x22
BUS=0

if [ $1 -eq 1 ]; then
	i2cset -y $BUS $CAM 0x12 0x00 0x03 0xC4 0x03 0xFF 0x00 0x00 i
        i2cset -y $BUS $CAM 0x12 0x00 0x03 0xCC 0x0A 0x0C 0x0E 0x10 i
        i2cset -y $BUS $CAM 0x12 0x00 0x03 0xD8 0x0A 0x0C 0x0E 0x10 i
elif [ $1 -eq 2 ]; then
	i2cset -y $BUS $CAM 0x12 0x00 0x03 0xC4 0x03 0xFF 0x00 0x00 i
	i2cset -y $BUS $CAM 0x12 0x00 0x03 0xCC 0x14 0x18 0x1C 0x20 i
        i2cset -y $BUS $CAM 0x12 0x00 0x03 0xD8 0x14 0x18 0x1C 0x20 i

elif [ $1 -eq 3 ]; then
 	i2cset -y $BUS $CAM 0x12 0x00 0x03 0xC4 0x03 0xFF 0x00 0x00 i
        i2cset -y $BUS $CAM 0x12 0x00 0x03 0xCC 0x28 0x30 0x38 0x40 i
        i2cset -y $BUS $CAM 0x12 0x00 0x03 0xD8 0x28 0x30 0x38 0x40 i

else
	echo "Valid values of contrast are: 1, 2, or 3"
fi
