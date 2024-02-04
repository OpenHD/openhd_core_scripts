#!/bin/bash

#script to setup OpenHD Cameras

#Raspberry
# Look for the version of Raspberry Pi running
uname_output=$(uname -a)
kernel_version=$(echo "$uname_output" | awk '{print $3}')
kernel_type=$(echo "$kernel_version" | awk -F '-' '{print $2}')

if [[ "$kernel_type" == "v7l+" ]]; then
  # kms
  board_type="rpi_4_"
elif [[ "$kernel_type" == "v7+" ]]; then
  # fkms
  board_type="rpi_3_"
fi

  # Look for the camera option selected by the user
  output=""
  configFileContent=$(</boot/openhd/camera.txt)


# Append the filename to the output variable and write it in lowercase
    filename=$(basename "$configFileContent" .txt | tr '[:upper:]' '[:lower:]')
    output_org="$files"
    output="$filename"

#Echo camera
echo $filename


#Rockchip

