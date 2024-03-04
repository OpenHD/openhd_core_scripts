cp /usr/local/share/openhd_misc/motd /etc/motd
cat /etc/motd

if [ -d /home/pi ]; then
    echo "activating autologin on raspberry pi"
    sudo sed -i 's/^ExecStart=-\/sbin\/agetty .*$/ExecStart=-\/sbin\/agetty --skip-login --login-options "-f root" %I 38400 linux/' /usr/lib/systemd/system/getty@.service
fi