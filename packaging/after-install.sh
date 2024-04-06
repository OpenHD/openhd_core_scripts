cp /usr/local/share/openhd_misc/motd /etc/motd
cat /etc/motd

if [ -d /home/pi ]; then
    echo "activating autologin on raspberry pi"
    sudo sed -i 's/^ExecStart=-\/sbin\/agetty .*$/ExecStart=-\/sbin\/agetty --skip-login --login-options "-f root" %I 38400 linux/' /usr/lib/systemd/system/getty@.service
fi

if [ ! -e "/usr/local/share/openhd_platform/x20" ]; then
    echo "Non Custom Installation Found"
    rm -Rf /usr/local/bin/x20/
    systemctl disable temperature_guardian.service
fi
