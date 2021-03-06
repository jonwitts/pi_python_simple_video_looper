#!/bin/bash

# Setup script to install our required software and 
# configure services etc.

# Make sure script is run as root.
if [ "$(id -u)" != "0" ]; then
  echo "Must be run as root with sudo! Try: sudo ./setup.sh"
  exit 1
fi

# update and upgrade existing packages
echo "Upgrading existing packages"
echo "=========================="
apt-get update
apt-get dist-upgrade -y

# install our required packages
echo "Installing dependencies..."
echo "=========================="
apt-get install wget omxplayer util-linux usbmount python3 -y
apt-get install python3-gpiozero -y
# include exFAT support
apt-get install exfat-fuse exfat-utils -y

# Configure USBMount for Stretch
# from https://vivekanandxyz.wordpress.com/2017/12/29/detecting-and-automatically-mounting-pendrive-on-raspbian-stretch-lite/
echo "Configure USBMount..."
echo "=========================="
sed -i '/MountFlags=slave/c\MountFlags=shared' /lib/systemd/system/systemd-udevd.service
systemctl daemon-reload

# copy our bash script
echo "Install our piPySimpleVideoLooper script..."
echo "=========================="
mkdir /piPySimpleVideoLooper
cd /piPySimpleVideoLooper
wget -N https://raw.githubusercontent.com/jonwitts/pi_python_simple_video_looper/master/piPySimpleVideoLooper.py
chmod +x ./piPySimpleVideoLooper.py

# copy our shutdown Python script
echo "Install our Python shutdown script..."
echo "=========================="
wget -N https://raw.githubusercontent.com/jonwitts/pi_python_simple_video_looper/master/pythonShutdown.py
chmod +x ./pythonShutdown.py

# copy and activate our systemd definitions
echo "Copy and activate our systemd definitions..."
echo "=========================="
# piSimpleVideoLooper service
wget -N https://raw.githubusercontent.com/jonwitts/pi_python_simple_video_looper/master/piPySimpleVideoLooper.service
mv ./piPySimpleVideoLooper.service /lib/systemd/system/piPySimpleVideoLooper.service
chmod 644 /lib/systemd/system/piPySimpleVideoLooper.service

# pythonShutdown service
wget -N https://raw.githubusercontent.com/jonwitts/pi_python_simple_video_looper/master/pythonShutdown.service
mv ./pythonShutdown.service /lib/systemd/system/pythonShutdown.service
chmod 644 /lib/systemd/system/pythonShutdown.service

# reload and enable
systemctl daemon-reload
systemctl enable piPySimpleVideoLooper.service
systemctl enable pythonShutdown.service

# copy our noVideo file
echo "Copy the noVideo holding file"
echo "=========================="
wget -N https://raw.githubusercontent.com/jonwitts/pi_python_simple_video_looper/master/noVideo.mp4

# done
echo "Done. Rebooting now"
echo "=========================="
reboot
