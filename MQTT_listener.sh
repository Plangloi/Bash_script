#!/bin/bash

# Configuration
MQTT_HOST="192.168.2.12"
MQTT_TOPIC="/dak/off"
MQTT_USER="mqtt-user"
MQTT_PASS="Password"
SCRIPT_USER="ipat"
SCRIPT_DIR="/home/ipat/Documents/Screen_on_off"

# Set display for GUI access
export DISPLAY=:0

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to execute script safely
execute_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    
    if [[ -f "$script_path" && -x "$script_path" ]]; then
        log_message "Executing $script_name"
        sudo -u "$SCRIPT_USER" DISPLAY=:0 "$script_path"
        if [[ $? -eq 0 ]]; then
            log_message "$script_name executed successfully"
        else
            log_message "Error executing $script_name"
        fi
    else
        log_message "Error: Script $script_path not found or not executable"
    fi
}

log_message "Starting MQTT listener on $MQTT_HOST for topic $MQTT_TOPIC"

# Subscribe to MQTT and process messages
mosquitto_sub -h "$MQTT_HOST" -t "$MQTT_TOPIC" -u "$MQTT_USER" -P "$MQTT_PASS" | while read -r payload; do
    log_message "Received payload: '$payload'"
    
    case "$payload" in
        "off")
            log_message "Screen OFF command received"
            execute_script "$SCRIPT_DIR/screen_off.sh"
            ;;
        "on")
            log_message "Screen ON command received"
            execute_script "$SCRIPT_DIR/screen_on.sh"
            ;;
        # "brightness_low")
        #     log_message "Low brightness command received"
        #     execute_script "$SCRIPT_DIR/brightness_low.sh"
        #     ;;
        # "brightness_high")
        #     log_message "High brightness command received"
        #     execute_script "$SCRIPT_DIR/brightness_high.sh"
        #     ;;
        # "restart")
        #     log_message "Restart command received"
        #     execute_script "$SCRIPT_DIR/restart_system.sh"
        #     ;;
        # "shutdown")
        #     log_message "Shutdown command received"
        #     execute_script "$SCRIPT_DIR/shutdown_system.sh"
        #     ;;
        # "screenshot")
        #     log_message "Screenshot command received"
        #     execute_script "$SCRIPT_DIR/take_screenshot.sh"
        #     ;;
        # "volume_up")
        #     log_message "Volume up command received"
        #     execute_script "$SCRIPT_DIR/volume_up.sh"
        #     ;;
        # "volume_down")
        #     log_message "Volume down command received"
        #     execute_script "$SCRIPT_DIR/volume_down.sh"
        #     ;;
        # "volume_mute")
        #     log_message "Volume mute command received"
        #     execute_script "$SCRIPT_DIR/volume_mute.sh"
        #     ;;
        *)
            log_message "Unknown payload: '$payload' - ignoring"
            ;;
    esac
done

log_message "MQTT listener stopped"
