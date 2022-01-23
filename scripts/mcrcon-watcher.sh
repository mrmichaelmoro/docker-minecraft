#!/bin/bash

## This script launches and watches the Minecraft RCON client which the
## webconsole connects to. The original webclient required SUDO priveleges
## to run a server within a screen. This forces the client to interact
## with a screen running a local RCON client instead without sudo privs.

PROCESS_NAME="mcrcon"
WATCHER_NAME="mcrcon-watcher"
WATCHER_CMD="screen -ls mcs | grep Detached"
PROCESS_CMD="screen -dmS mcs /mcrcon -p $RCON_PASSWORD"

# Naive check runs checks once a minute to see if the process has exited.
# Otherwise it loops forever, waking up every 10 seconds

while sleep 10; do
  netstat -tuln | grep :$RCON_PORT > /dev/null
  if [ $? -eq 0 ]; then

    $WATCHER_CMD > /dev/null
    PROCESS_STATUS=$?

    if [ $PROCESS_STATUS -ne 0 ]; then
        TIMESTAMP=`date +%H:%M:%S`
        echo "[$TIMESTAMP] [$WATCHER_NAME/WARN]:  $PROCESS_NAME not running. Restarting..." >> /data/logs/latest.log
        $PROCESS_CMD
    fi
  fi
done
