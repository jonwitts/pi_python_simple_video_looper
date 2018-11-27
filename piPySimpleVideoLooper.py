#!/usr/bin/python3

# A simple video looper for the Raspberry Pi using Python
#
# author: Jon Witts
# license: GPL-3.0, see LICENSE included in this package
#
# A Python3 Video Looper for the Raspberry Pi and a Python3 shutdown button and LED indicator
# https://github.com/jonwitts/pi_python_simple_video_looper

# Import our libraries
import os
from subprocess import call
from time import sleep
from gpiozero import Button

# Define our constants
EXTENSIONS = ('.mp4','.MP4','.AVI','.avi')
PLAY = Button(14)

# first find the first attached USB drive
# scan in reverse order to find the first!
mounts = ["/media/usb7", "/media/usb6", "/media/usb5", "/media/usb4", "/media/usb3", "/media/usb2", "/media/usb1", "/media/usb0", "/media/usb"]

# define usbmount incase we don't find a usbdrive
usbmount = '/piPySimpleVideoLooper'

for i in mounts:
    if os.path.ismount(i):
        usbmount=i

PATH = usbmount

# define filePlay incase we don't find a file
filePlay = PATH + "noVideo.mp4"

# now search the drive for mp4 and avi files
for file in os.listdir(PATH):
    if file.endswith(EXTENSIONS):
        filePlay = os.path.join(PATH, file)

# Wait for button press to start playing
print("press the button (GPIO14) to play")
PLAY.wait_for_press()
# now play the last video file found, looping it with omxplayer
#omxplayer -b --loop --adev both filePlay
call(["omxplayer", "-b", "--loop", "--adev", "both", filePlay])
