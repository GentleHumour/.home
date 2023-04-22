#!/bin/bash

speak()
{
    local IFS=+
    # Use Google translation server to synthesise speech.
    url="http://translate.google.com/translate_tts?tl=en&q="$*""
    /usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "$url" 2>/dev/null
}

speak "$*"

