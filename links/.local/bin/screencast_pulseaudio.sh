#!/bin/bash
pactl load-module module-null-sink sink_name=CombinedAudio sink_properties=\'device.description=\"Mic and Application Output\"\'
pactl load-module module-loopback sink=CombinedAudio source=alsa_input.pci-0000_00_1b.0.analog-stereo
pactl load-module module-loopback sink=CombinedAudio source=alsa_output.pci-0000_00_1b.0.analog-stereo.monitor
pavucontrol &

