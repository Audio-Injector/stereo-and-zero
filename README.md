# stereo and zero

[If you want to discuss these products, or topics around hearing, acoustics and audio, join the audio injector email list.](https://lists.audioinjector.net/mailman/listinfo/people)

# setup
Upon recently testing Rasbian (2022-01-28 version) I was happy to find that setting up audio has become much easier. We can even keep pulseaudio operating which is the default and simplest approach for new users.

## Alter /boot/config.txt

The first thing to do is to update boot.txt using an editor, like nano :
* nano /boot/config.txt
* Add this to the end of the file : dtoverlay=audioinjector-wm8731-audio

Mine looks like this (using the tail command) :
```
pi@raspberrypi:~ $ tail -n1 /boot/config.txt 
dtoverlay=audioinjector-wm8731-audio
```

Once that is done, reboot. You should be able to see your sound card :
```
pi@raspberrypi:~ $ aplay -l
**** List of PLAYBACK Hardware Devices ****
[ SNIP ]
card 2: audioinjectorpi [audioinjector-pi-soundcard], device 0: AudioInjector audio wm8731-hifi-0 [AudioInjector audio wm8731-hifi-0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

```
## Enable "Output Mixer HiFi"
If you want to do this using alsamixer, run that command from the terminal, press F6 on your keyboard and select the correct audioinjector soundcard. Next use the L+R arrow keys to navigate to the "Output Mixer HiFi" control and press "m" on the keyboard to change its state from mute ("MM") to on ("OO").

Another way to do this is to use the amixer command line :
```
amixer -D hw:CARD=audioinjectorpi set 'Output Mixer HiFi' unmute
```


## Setup pulse audio to use the audio injector as output
Right click on the sound icon on the top right of the screen and in the outputs section, go to "Audio Outputs" and select the audio injector soundcard as the output.



#
#
#
#


# OLD NOTES BELOW

# setup

To setup your system :

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

NOTE : Find the files mentioned in this section here : https://github.com/Audio-Injector/stereo-and-zero/tree/master/audio.injector.scripts-0.1
Store the asound.*.test mixer setting files in /usr/share/doc/audioInjector to run the audioInjector-test.sh file.

Included are also two reference alsa mixer files which will allow you to setup default output with either line input or microphone input :

* asound.state.MIC.thru.test : This will setup the microphone as the input and also setup the output. Run
```
alsactl --file asound.state.MIC.thru.test restore
# if you put the file in /usr/share/doc/audioInjector 
alsactl --file /usr/share/doc/audioInjector/asound.state.MIC.thru.test restore
```
* asound.state.RCA.thru.test : This will setup the RCA lines as the input and also setup the output. Run
```
alsactl --file asound.state.RCA.thru.test restore
# if you put the file in /usr/share/doc/audioInjector 
alsactl --file /usr/share/doc/audioInjector/asound.state.RCA.thru.test restore
```

# Testing
There is a test script which plays a pulsing 10 kHz tone at high volume through the system. To use it, make sure you don't have speakers plugged in ! Plug in an RCA cable from input to output (Red to Red, White to White). Also plug cheap headphones into the headphone jack and place them near to the Audio Injector so that the microphone can hear them. Lastly run the script :
```
audioInjector-test.sh
```
It should plot the spectrograms which show the pulsing 10 kHz signal :
![spectrogram example](https://github.com/Audio-Injector/stereo-and-zero/blob/master/stereo.test.png)
