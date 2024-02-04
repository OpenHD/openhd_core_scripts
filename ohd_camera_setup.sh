#!/bin/bash

# Define all Camera types

case $config_file_content in
            # Raspberry
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
            # Rockchip
            70) cam_type="X_CAM_TYPE_ROCK_5_HDMI_IN"; cam_ident="" ;;
            71) cam_type="X_CAM_TYPE_ROCK_5_OV5647"; cam_ident="rpi-camera-v1_3" ;;
            72) cam_type="X_CAM_TYPE_ROCK_5_IMX219"; cam_ident="rpi-camera-v2" ;;
            73) cam_type="X_CAM_TYPE_ROCK_5_IMX708"; cam_ident="imx708" ;;
            74) cam_type="X_CAM_TYPE_ROCK_5_IMX462"; cam_ident="arducam-pivariety" ;;
            75) cam_type="X_CAM_TYPE_ROCK_5_IMX415"; cam_ident="radxa-camera-4k" ;;
            76) cam_type="X_CAM_TYPE_ROCK_5_OHD_Jaguar"; cam_ident="ohd-jaguar" ;;
            80) cam_type="X_CAM_TYPE_ROCK_3_HDMI_IN"; cam_ident="" ;;
            81) cam_type="X_CAM_TYPE_ROCK_3_OV5647"; cam_ident="rpi-camera-v1.3" ;;
            82) cam_type="X_CAM_TYPE_ROCK_3_IMX219"; cam_ident="rpi-camera-v2" ;;
            83) cam_type="X_CAM_TYPE_ROCK_3_IMX708"; cam_ident="imx708" ;;
            84) cam_type="X_CAM_TYPE_ROCK_3_OHD_Jaguar"; cam_ident="ohd-jaguar" ;;
            # OpenHD
            90) cam_type="X_CAM_TYPE_X20_RUNCAM_NANO";;
            91) cam_type="X_CAM_TYPE_X20_RUNCAM_90";;
            92) cam_type="X_CAM_TYPE_X20_OHD_Jaguar";;
            # Enterprise
            101) cam_type="X_CAM_TYPE_AGX_IMX577";;
            *) cam_type="Unknown"; cam_link="unknown_link"; cma=false ;;
        esac


# Determine Platform and board type
uname_output=$(uname -a)
kernel_version=$(echo "$uname_output" | awk '{print $3}')
kernel_type=$(echo "$kernel_version" | awk -F '-' '{print $2}')

if [[ "$kernel_type" == "v7l+" ]]; then
    board_type="rpi_4_"
    platform=rpi
    supported_platform=true
elif [[ "$kernel_type" == "v7+" ]]; then
    board_type="rpi_3_"
    platform=rpi
    supported_platform=true
elif echo "$kernel_version" | grep -q "rk356"; then
    board_type="rk3566"
    platform=rockchip
    supported_platform=true
elif echo "$kernel_version" | grep -q "rk358"; then
    board_type="rk3588"
    platform=rockchip
    supported_platform=true
elif echo "$kernel_version" | grep -q "x20"; then
    board_type="x20"
    platform=openhd
    supported_platform=true
else
    supported_platform=false
fi

if [[ "$supported_platform" == true ]]; then
    echo $platform
    echo $board_type
    if [[ "$platform" == "rpi" ]]; then
        echo "This Platform is a Raspberry Pi"

        # Read camera configuration from file
        config_file="/boot/openhd/camera1.txt"
        config_file_content=$(<$config_file)

        # Copy better tuning file for 477m
        if [[ "$cam_type" == X_CAM_TYPE_RPI_LIBCAMERA_ARDUCAM_IMX477M ]]; then
            if [ -e /usr/share/libcamera/ipa/raspberrypi/imx477_old.json ]; then
                echo "No Custom Tuning needed!"
            else
                mv /usr/share/libcamera/ipa/raspberrypi/imx477.json /usr/share/libcamera/ipa/raspberrypi/imx477_old.json
                cp /usr/share/libcamera/ipa/raspberrypi/arducam-477m.json /usr/share/libcamera/ipa/raspberrypi/imx477.json
            fi
        elif [[ "$cam_type" == X_CAM_TYPE_RPI_LIBCAMERA_RPIF_HQ_IMX477 ]]; then
            if [ -e /usr/share/libcamera/ipa/raspberrypi/imx477_old.json ]; then
                rm /usr/share/libcamera/ipa/raspberrypi/imx477.json
                mv /usr/share/libcamera/ipa/raspberrypi/imx477_old.json /usr/share/libcamera/ipa/raspberrypi/imx477.json
                rm /usr/share/libcamera/ipa/raspberrypi/imx477_old.json
            else
                echo "No Custom Tuning needed!"
            fi
        fi

        # Preparing everything
        echo "Camera Type: $cam_type"
        echo "Current Config:" 
        cp /boot/config.txt /boot/config.txt.bak
        grep '^dtoverlay' /boot/config.txt
        sed -i '/#OPENHD_DYNAMIC_CONTENT_BEGIN#/q' /boot/config.txt

        # Create Overlay
        ## Line 1
        if [[ "$cma" == true ]]; then
            append=",cma=400M"
        else
            append=""
        fi

        if [[ "$board_type" == "rpi_4_" ]]; then
            dtoverlayL1="dtoverlay=vc4-$cam_link-v3d${append}"
        elif [[ "$board_type" == "rpi_3_" ]]; then
            dtoverlayL1="dtoverlay=vc4-fkms-v3d${append}"
        fi

        echo $dtoverlayL1

        ## Line 2
        dtoverlayL2="dtoverlay=$cam_ident"

        echo $dtoverlayL2

    elif [[ "$board_type" == "rk3566" ]]; then
        echo "This Platform is Rockchip based and a RK3566 SOC"
        if apt list --installed | grep -q "u-boot-radxa-zero3"; then
            # Search for lines containing "append" in the extlinux.conf file
            lines=$(grep -n "append" /boot/extlinux/extlinux.conf | cut -d':' -f1)

            #Loop through each line number and check for the presence of "video"
            for line in $lines; do
                if grep -n "append" /boot/extlinux/extlinux.conf | cut -d: -f1 | grep -q $line; then
                    echo "Line $line: append is here!"
                    awk -i inplace -v line="$((line-1))" 'NR == line {print "hello world"} {print}' /boot/extlinux/extlinux.conf
                    break
                else
                    echo "failed to read correct file."
                fi
            done

            else
                echo "false"
            fi
        fi
    elif [[ "$board_type" == "rk3588" ]]; then
        echo "This Platform is Rockchip based and a RK3588 SOC"
    else
        echo "This platform is not supported"
    fi
