# stereo and zero
# setup
I have some scripts which allow you to easily setup your /boot/config.txt to load the correct audio injector device tree. The raspbian inastallable .deb package is attached, first unarchive it and then install the deb package.[attachment=0]audio.injector.scripts_0.1-1_all.deb.tar.gz[/attachment]

To setup your system (if you want to do this manually, look at the end of this message) :
[b]Automated setup method[/b]
[list]Download and install the attached deb file.[/list]
[list]Run audioInjector-setup.sh command from the command line (by typing it in and pressing return).[code]audioInjector-setup.sh[/code] This script will update your firmware firstly (by running rpi-update) and then alter your /boot/config.txt file to add the device tree to load (dtoverlay=audioinjector-wm8731-audio).[/list]
[list]Reboot to force the correct device tree to load.[/list]

[b]Mixer settings[/b]
Turn up the manual volume control knobs on the card - to a desired level !
Included are also two reference alsa mixer files which will allow you to setup default output with either line input or microphone input :
* asound.state.MIC.thru.test : This will setup the microphone as the input and also setup the output. Run [code]alsactl --file /usr/share/doc/audioInjector/asound.state.MIC.thru.test restore[/code]
* asound.state.RCA.thru.test : This will setup the RCA lines as the input and also setup the output. Run [code]alsactl --file /usr/share/doc/audioInjector/asound.state.RCA.thru.test restore[/code]

[b]Testing[/b]
There is a test script which plays a pulsing 10 kHz tone at high volume through the system. To use it, make sure you don't have speakers plugged in ! Plug in an RCA cable from input to output (Red to Red, White to White). Also plug cheap headphones into the headphone jack and place them near to the Audio Injector so that the microphone can hear them. Lastly run the script :[code]audioInjector-test.sh[/code]
It should plot the spectrograms which show the pulsing 10 kHz signal [attachment=1]test.screenshot.png[/attachment].

[b]Manual setup method[/b]
[list]Ensure you have the latest kernel : sudo rpi-update[/list]
[list]Make sure the default audio device tree is not loaded for PWM output (/boot/config.txt), this is because it uses the same I2S bus. (Comment out dtparam=audio=on)[/list]
[list]Make sure the Audio Injector device tree is loaded at boot time : dtoverlay=audioinjector-wm8731-audio[/list]
[list]Reboot to force the correct device tree to load.[/list]
