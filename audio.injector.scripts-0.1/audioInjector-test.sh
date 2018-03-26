#!/bin/bash
# Author : Matt Flax <flatmax@flatmax.org>
# Date : 2016.06.29
# Copyright : Flatmax Pty Ltd

APLAY=`which aplay`
if [ -z "$APLAY" ]; then
	echo couldn\'t find the aplay command please install the alsa-utils pacakge
	exit 1
fi

SOX=`which sox`
if [ -z "$SOX" ]; then
	echo couldn\'t find the sox command please install the sox pacakge
	echo sudo apt-get install sox
	exit 2
fi

# check the sound card is detected
present=`aplay -l 2>&1 | grep -c 'no soundcards found'`
if [ "$present" -eq "1" ]; then
	echo
	echo sound card not found, is it plugged in correctly \?
	echo is it broken \?
	echo please turn off, fix/change and turn on again.
	echo
	read line
fi

while true; do
rm -f /tmp/test.wav /tmp/spectrogram.png /tmp/test.mic.wav /tmp/spectrogram.mic.png
killall play
killall arecord
killall gpicview
sleep 3.5
# first restore the alsa mixer to enable output, line capture, and 0 dB levels
alsactl --file /usr/share/doc/audioInjector/asound.state.RCA.thru.test restore

# play and record
#play -n synth 3 sin 100 sin 1000 sin 10000 &
play -r 48k -b 16 -c 2 -n synth 3 sin 10000 gain -6 tremolo 2 100  &
arecord -r 48000 -f S16_LE -c 2 -d 2 /tmp/test.wav
sox /tmp/test.wav -n spectrogram -o /tmp/spectrogram.png
xdg-open /tmp/spectrogram.png &

sleep 2

# now restore the alsa mixer to enable output, mic capture, and boost
alsactl --file /usr/share/doc/audioInjector/asound.state.MIC.thru.test restore

play -r 48k -b 16 -c 2 -n synth 3 sin 10000 gain -6 tremolo 2 100  &
arecord -r 48000 -f S16_LE -c 2 -d 2 /tmp/test.mic.wav
sox /tmp/test.mic.wav -n spectrogram -o /tmp/spectrogram.mic.png
xdg-open /tmp/spectrogram.mic.png


echo press enter to test again, any other key then enter to exit
read line
if [ ! -z $line ]; then
	exit 0;
fi
done
