# Use a base image with cron installed
FROM debian:bullseye-slim

# Install cron and any other dependencies if needed
RUN apt-get update && apt-get install -y cron curl && rm -rf /var/lib/apt/lists/*

RUN echo "* * * * *     root    /scripts/set-smart-socket-state-based-on-percentage.sh >> /var/log/set-smart-socket-state-based-on-percentage.log" >> /etc/crontab

# Create a directory to store your scripts
RUN mkdir /scripts

# Copy your script files into the container
COPY scripts/ /scripts/

# Add your entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create log file for cron script output
RUN touch /var/log/set-smart-socket-state-based-on-percentage.log

# Make all script files in /scripts executable
RUN find /scripts -type f -exec chmod +x {} \;

ENV SOCKET_ON_THRESHOLD=20
ENV SOCKET_OFF_THRESHOLD=100
ENV HUE_BRIDGE_IP=""
ENV HUE_BRIDGE_USERNAME=""
ENV HUE_BRIDGE_SOCKET_ID=""
ENV BATTERY_INFO_ENV_VAR_FILE="/battery/uevent"

ENTRYPOINT ["/entrypoint.sh"]