# stereo and zero

[If you want to discuss these products, or topics around hearing, acoustics and audio, join the audio injector email list.](https://lists.audioinjector.net/mailman/listinfo/people)

# setup

To setup your system (if you want to do this manually, look at the end of this message) :

NOTE 

New versions of raspbian have a non-robust configuration of pulseaudio installed. You should probably skip the autoinstall method and use the manual installation method - which removes pulseaudio first.

END NOTE

# Manual setup method
* Uninstall pulseaudio first - current Rasbian releases have a non-robust config for it and it breaks operation : sudo apt remove pulseaudio
* Make sure the default audio device tree is not loaded for PWM output (/boot/config.txt), this is because it uses the same I2S bus. (Comment out dtparam=audio=on)
* Make sure the Audio Injector device tree is loaded at boot time : dtoverlay=audioinjector-wm8731-audio
* Reboot to force the correct device tree to load.

# Automated setup method
NOTE : People are reporting that non-robust pulseaudio configuration is creating problems with the auto-installation method, if you have problems (with newer Rasbian releases, you should perform the manual installation method below).

I have some scripts which allow you to easily setup your /boot/config.txt to load the correct audio injector device tree. The raspbian inastallable .deb package is available from the link below, download and install it.
https://github.com/Audio-Injector/stereo-and-zero/raw/master/audio.injector.scripts_0.1-1_all.deb

1. Download and install the attached deb file.

2. Run audioInjector-setup.sh command from the command line (by typing it in and pressing return).
```
audioInjector-setup.sh
```  
This script will update your firmware firstly (by running rpi-update) and then alter your /boot/config.txt file to add the device tree to load (dtoverlay=audioinjector-wm8731-audio).

3. Reboot to force the correct device tree to load.

4. Don't forget to enable the output HiFi mixer using alsamixer or this on the commandline : amixer set 'Output Mixer HiFi' on

# Mixer settings
Turn up the manual volume control knobs on the card - to a desired level !

Included are also two reference alsa mixer files which will allow you to setup default output with either line input or microphone input :

* asound.state.MIC.thru.test : This will setup the microphone as the input and also setup the output. Run
```
alsactl --file /usr/share/doc/audioInjector/asound.state.MIC.thru.test restore
```
* asound.state.RCA.thru.test : This will setup the RCA lines as the input and also setup the output. Run
```
alsactl --file /usr/share/doc/audioInjector/asound.state.RCA.thru.test restore
```

# Testing
There is a test script which plays a pulsing 10 kHz tone at high volume through the system. To use it, make sure you don't have speakers plugged in ! Plug in an RCA cable from input to output (Red to Red, White to White). Also plug cheap headphones into the headphone jack and place them near to the Audio Injector so that the microphone can hear them. Lastly run the script :
```
audioInjector-test.sh
```
It should plot the spectrograms which show the pulsing 10 kHz signal :
![spectrogram example](https://github.com/Audio-Injector/stereo-and-zero/blob/master/stereo.test.png)
