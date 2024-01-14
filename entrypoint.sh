#!/bin/bash -l

# Function to check if a required environment variable is set
check_env_var() {
  if [ -z "${!1}" ]; then
    echo "Error: Environment variable $1 is not set."
    exit 1
  fi
}

# Check that the required environment variables are set
check_env_var "SOCKET_ON_THRESHOLD"
check_env_var "SOCKET_OFF_THRESHOLD"
check_env_var "HUE_BRIDGE_IP"
check_env_var "HUE_BRIDGE_USERNAME"
check_env_var "HUE_BRIDGE_SOCKET_ID"
check_env_var "BATTERY_INFO_ENV_VAR_FILE"

# Check if a required file exists
if [ ! -f "$BATTERY_INFO_ENV_VAR_FILE" ]; then
  echo "Error: The required file '$BATTERY_INFO_ENV_VAR_FILE' does not exist."
  exit 1
fi

# send environment variables to /container.env so that the cron scripts can get them as they are not propagated by crontab
declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

# Start the cron service
cron && tail -f /var/log/set-smart-socket-state-based-on-percentage.log
