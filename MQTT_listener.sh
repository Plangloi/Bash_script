#!/bin/bash

export DISPLAY=:0  # Set display for GUI access

mosquitto_sub -h 192.168.2.12 -t "/dak/off" -u "mqtt-user" -P "Password" | while read -r payload; do
    if [[ "$payload" == "off" ]]; then
        echo "Received OFF message, executing script.sh"
        sudo -u ipat DISPLAY=:0 /home/ipat/Documents/Screen_on_off/screen_off.sh

    fi
done               
