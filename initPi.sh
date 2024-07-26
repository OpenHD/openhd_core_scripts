#!/bin/bash

# Look for the version of Raspberry Pi running
uname_output=$(uname -a)
kernel_version=$(echo "$uname_output" | awk '{print $3}')
kernel_type=$(echo "$kernel_version" | awk -F '-' '{print $2}')


if [[ -e "/usr/local/share/openhd_platform/rpi/" ]]; then
    echo "Running on a raspberry pi "
        if [[ -f "/boot/openhd/resize.txt" ]]; then
        mkdir -p /run/openhd/
        touch /run/openhd/hold.pid
        echo resizing partition
        parted /dev/mmcblk0 --script resizepart 3 100%
        sudo rm /boot/openhd/resize.txt
        sudo mkfs.vfat -F 32 -n "RECORDINGS" /dev/mmcblk0p3
        sudo parted /dev/mmcblk0 set 3 lba on
        reboot
        fi
fi

if [[ "$kernel_type" == "v7l+" ]]; then
  # kms
  board_type="rpi_4_"
elif [[ "$kernel_type" == "v7+" ]]; then
  # fkms
  board_type="rpi_3_"
fi

### Check if it is a groundstation and if yes, exit

if [ -e /boot/openhd/ground.txt ]; then 
rm -Rf /boot/openhd/rpi.txt
exit 0
fi

if [ -e /boot/openhd/air.txt ]; then 
  if [ -e /boot/openhd/camera1.txt ] && [ ! -e /boot/openhd/camera.txt ]; then 
  bash /usr/local/bin/ohd_camera_setup.sh > /boot/openhd/camera.txt
  reboot
  fi
exit 0
fi

# if [ ! -e /boot/openhd-camera.txt ]; then
#   ### Configure the camera

#   # Look for the camera option selected by the user
#   output=""
#   # Use find to locate all .txt files in the /boot/openhd directory
#   # and then use grep to exclude the unwanted filenames
#   files=$(find /boot/openhd -type f -name "*.txt" | grep -Ev "rpi\.txt|air\.txt|ground\.txt|debug\.txt")

#   # Use a loop to iterate through the filtered filenames
#   # for file in $files; do
#   #     # Append the filename to the output variable and write it in lowercase
#   #     filename=$(basename "$file" .txt | tr '[:upper:]' '[:lower:]')
#   #     output_org="$files"
#   #     output="$filename"
#   # done

#   # Now we remove everything after the #OPENHD_DYNAMIC_CONTENT_BEGIN# from the OpenHD config file
#   # rm /boot/openhd/rpi.txt
#   # cp /boot/config.txt /boot/config.txt.bak

#   # # Now we build the filename for the config file
#   # if [[ "$output" == "" ]]; then
#   #   echo "mmal"
#   #   echo "0" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   #   exit 0
#   # elif [[ "$output" == "imx327" ]] || [[ "$output" == "cam2m" ]] || [[ "$output" == "csimx307" ]] || [[ "$output" == "mvcam" ]] || [[ "$output" == "cssc132" ]]; then
#   #   camera_type="veye_"
#   #   sed -i '/#OPENHD_DYNAMIC_CONTENT_BEGIN#/q' /boot/config.txt
#   # else
#   # sed -i '/#OPENHD_DYNAMIC_CONTENT_BEGIN#/q' /boot/config.txt
#   # camera_type="libcamera_"
#   # fi

#   camera_config=$board_type$camera_type$output".txt"
#   camera_link="/boot/openhd/rpi_camera_configs/"$camera_config

#   #Now we copy the camera-configuation after the #OPENHD_DYNAMIC_CONTENT_BEGIN# lines:
#   cat "$camera_link" >> /boot/config.txt

#   sudo openhd -a --run-time-seconds 3 --continue-without-wb-card

#   if [[ "$output" == "mmal" ]]; then
#   echo "0" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 0"
#   elif [[ "$output" == "arducam" ]]; then
#   echo "1" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 1"
#   elif [[ "$output" == "imx708" ]]; then
#   echo "2" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 2"
#   elif [[ "$output" == "imx519" ]]; then
#   echo "3" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 3"
#   elif [[ "$output" == "imx477" ]]; then
#   echo "5" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 5"
#   elif [[ "$output" == "imx462" ]]; then
#   echo "6" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 6"
#   elif [[ "$output" == "imx326" ]]; then
#   echo "7" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 7"
#   elif [[ "$output" == "imx290" ]]; then
#   echo "8" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 8"
#   elif [[ "$output" == "veye2mp" ]]; then
#   echo "11" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 11"
#   elif [[ "$output" == "csimx307" ]]; then
#   echo "12" >  /usr/local/share/openhd/video/curr_rpi_cam_config.tx
#   echo "writing binary camera identifier 12"
#   elif [[ "$output" == "ssc132" ]]; then
#   echo "13" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 13"
#   elif [[ "$output" == "mvcam" ]]; then
#   echo "14" >  /usr/local/share/openhd/video/curr_rpi_cam_config.txt
#   echo "writing binary camera identifier 14"
#   fi

#   echo "Config for" $camera_config "was written successfully"
#   touch /boot/openhd-camera.txt
#   echo $output > /boot/openhd-camera.txt
#   reboot
# fi