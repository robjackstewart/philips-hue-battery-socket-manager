#!/bin/bash

# get the e environment variables populated by the entrypoint
source /container.env

# Function to turn on the Philips Hue socket
turn_on_hue_socket() {
    curl -X PUT -d '{"on":true}' "http://$HUE_BRIDGE_IP/api/$HUE_BRIDGE_USERNAME/lights/$HUE_BRIDGE_SOCKET_ID/state"
}

# Function to turn off the Philips Hue socket
turn_off_hue_socket() {
    curl -X PUT -d '{"on":false}' "http://$HUE_BRIDGE_IP/api/$HUE_BRIDGE_USERNAME/lights/$HUE_BRIDGE_SOCKET_ID/state"
}

# Function to check battery level
check_battery_level() {
    battery_percentage=$(cat $BATTERY_PERCENTAGE_FILE)
    echo "$battery_percentage"
}

# Main script logic
battery_level=$(check_battery_level)

echo "battery percentage is $battery_level"

if [ "$battery_level" -le "$SOCKET_ON_THRESHOLD" ]; then
    # Battery is less than $SOCKET_OFF_THRESHOLD, turn on the Philips Hue socket
    turn_on_hue_socket
    echo "Battery level is less than $SOCKET_ON_THRESHOLD. Turning on the Philips Hue socket."
elif [ "$battery_level" -ge "$SOCKET_OFF_THRESHOLD" ]; then
    # Battery is $SOCKET_ON_THRESHOLD, turn off the Philips Hue socket
    turn_off_hue_socket
    echo "Battery level is $SOCKET_OFF_THRESHOLD. Turning off the Philips Hue socket."
else
    echo "Battery level is between $SOCKET_ON_THRESHOLD and $SOCKET_OFF_THRESHOLD. No action required."
fi
