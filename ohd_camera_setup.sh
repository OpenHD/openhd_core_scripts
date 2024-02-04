#!/bin/bash

# Script to setup OpenHD Cameras

# Determine Raspberry Pi board type
uname_output=$(uname -a)
kernel_version=$(echo "$uname_output" | awk '{print $3}')
kernel_type=$(echo "$kernel_version" | awk -F '-' '{print $2}')

if [[ "$kernel_type" == "v7l+" ]]; then
    board_type="rpi_4_"
elif [[ "$kernel_type" == "v7+" ]]; then
    board_type="rpi_3_"
fi

# Read camera configuration from file
config_file="/boot/openhd/camera.txt"
config_file_content=$(<$config_file)

# Define camera types
case $config_file_content in
    0) cam_type="X_CAM_TYPE_DUMMY_SW" ;;
    1) cam_type="X_CAM_TYPE_USB" ;;
    2) cam_type="X_CAM_TYPE_EXTERNAL" ;;
    3) cam_type="X_CAM_TYPE_EXTERNAL_IP" ;;
    4) cam_type="X_CAM_TYPE_DEVELOPMENT_FILESRC" ;;
    10) cam_type="X_CAM_TYPE_RPI_MMAL_HDMI_TO_CSI" ;;
    20) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_RPIF_V1_OV5647" ;;
    21) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_RPIF_V2_IMX219" ;;
    22) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_RPIF_V3_IMX708" ;;
    23) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_RPIF_HQ_IMX477" ;;
    30) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_SKYMASTERHDR" ;;
    31) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_SKYVISIONPRO" ;;
    32) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX477M" ;;
    33) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX462" ;;
    34) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX327" ;;
    35) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX290" ;;
    36) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX462_LOWLIGHT_MINI" ;;
    50) cam_type="X_CAM_TYPE_RPI_V4L2_VEYE_2MP" ;;
    51) cam_type="X_CAM_TYPE_RPI_V4L2_VEYE_CSIMX307" ;;
    52) cam_type="X_CAM_TYPE_RPI_V4L2_VEYE_CSSC132" ;;
    53) cam_type="X_CAM_TYPE_RPI_V4L2_VEYE_CSSC132" ;;
    *) cam_type="Unknown" ;;
esac

# Echo camera type
echo "Camera Type: $cam_type"

# Remove unnecessary lines from OpenHD config file
sed -i '/#OPENHD_DYNAMIC_CONTENT_BEGIN#/,$d' /boot/openhd/rpi.txt
cp /boot/config.txt /boot/config.txt.bak

# Rockchip setup goes here
