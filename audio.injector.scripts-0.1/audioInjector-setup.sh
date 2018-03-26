#!/bin/bash
# Author : Matt Flax <flatmax@flatmax.org>
# Date : 2016.07.08
# Copyright : Flatmax Pty Ltd

echo updating the kernel
sudo rpi-update

# check the device tree overlay is setup correctly ...
# firstly disable PWM audio
sudo bash -c "sed -i \"s/^\s*dtparam=audio/#dtparam=audio/\" /boot/config.txt"
# now check to see the correct device tree overlay is loaded ...
cnt=`grep -c audioinjector-wm8731-audio /boot/config.txt`
if [ "$cnt" -eq "0" ]; then
	sudo bash -c "echo '# enable the AudioInjector.net sound card
	dtoverlay=audioinjector-wm8731-audio' >> /boot/config.txt"
fi

echo
echo The audio injector sound card is now setup.
echo Please reboot to enable the correct device tree.
echo

