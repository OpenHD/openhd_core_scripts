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
    0) cam_type="X_CAM_TYPE_DUMMY_SW"; cma=false ;;
    1) cam_type="X_CAM_TYPE_USB"; cma=false ;;
    2) cam_type="X_CAM_TYPE_EXTERNAL"; cma=false ;;
    3) cam_type="X_CAM_TYPE_EXTERNAL_IP"; cma=false ;;
    4) cam_type="X_CAM_TYPE_DEVELOPMENT_FILESRC"; cma=false ;;
    10) cam_type="X_CAM_TYPE_RPI_MMAL_HDMI_TO_CSI"; cam_link="fkms"; cma=false ;;
    20) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_RPIF_V1_OV5647"; cam_link="kms"; cam_ident="ov5647"; cma=false ;;
    21) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_RPIF_V2_IMX219"; cam_link="kms"; cam_ident="imx219"; cma=false ;;
    22) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_RPIF_V3_IMX708"; cam_link="kms"; cam_ident="imx708"; cma=false ;;
    23) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_RPIF_HQ_IMX477"; cam_link="kms"; cam_ident="imx477"; cma=false ;;
    30) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_SKYMASTERHDR"; cam_link="kms"; cam_ident="imx708"; cma=true ;;
    31) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_SKYVISIONPRO"; cam_link="kms"; cam_ident="imx519"; cma=true ;;
    32) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX477M"; cam_link="kms"; cam_ident="imx477"; cma=true ;;
    33) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX462"; cam_link="kms"; cam_ident="imx462"; cma=true ;;
    34) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX327"; cam_link="kms"; cam_ident="imx327"; cma=true ;;
    35) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX290"; cam_link="kms"; cam_ident="arducam-pivariety"; cma=true ;;
    36) cam_type="X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX462_LOWLIGHT_MINI"; cam_link="kms"; cam_ident="arducam-pivariety"; cma=true ;;
    50) cam_type="X_CAM_TYPE_RPI_V4L2_VEYE_2MP"; cam_link="kms"; cam_ident="veyecam2m-overlay"; cma=false ;;
    51) cam_type="X_CAM_TYPE_RPI_V4L2_VEYE_CSIMX307"; cam_link="kms"; cam_ident="csimx307-overlay"; cma=false ;;
    52) cam_type="X_CAM_TYPE_RPI_V4L2_VEYE_CSSC132"; cam_link="kms"; cam_ident="cssc132-overlay"; cma=false ;;
    53) cam_type="X_CAM_TYPE_RPI_V4L2_VEYE_MVCAM"; cam_link="kms"; cam_ident="veye_mvcam-overlay"; cma=false ;;
    *) cam_type="Unknown"; cam_link="unknown_link"; cma=false ;;
esac


# Echo camera type
echo "Camera Type: $cam_type"
echo "Current Config:" 
grep '^dtoverlay' /boot/config.txt


# Create Overlay
##Line1
if [[ "$cma" == true ]]; then
  append=",cma=400M"
else
  append=""
fi

if [[ "$board_type" == "rpi_4_" ]]; then
dtoverlayL1="vc4-"$cam_link"-v3d${append}"
elif [[ "$board_type" == "rpi_3_" ]]; then
dtoverlayL1="vc4-fkms-v3d${append}"
fi

##Line2
dtoverlayL2=
echo $dtoverlayL1

# Remove unnecessary lines from OpenHD config file
#sed -i '/#OPENHD_DYNAMIC_CONTENT_BEGIN#/,$d' /boot/openhd/rpi.txt
#cp /boot/config.txt /boot/config.txt.bak

# Rockchip setup goes here
