#!/bin/bash 

# This script preps the container with required services which run in the background.
# ie. Apache, MCRCON, etc.

# Next command to run to initiate the application in docker. This should be the script or commmand
# which will be the running process within docker. 
ENTRY_POINT="/start"

# Pre-reqs
OS=`cat /etc/*-release | grep "^ID=" | cut -f2 -d"=" | sed s/\"//g`

case $OS in
	ubuntu) a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests
			APACHE_CMD="/etc/init.d/apache2 start" ;;
	*) APACHE_CMD="/usr/sbin/httpd" ;;

esac

# Start the apache process process
$APACHE_CMD
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Apache: $status"
  exit $status
fi

# Fork and background the apache-watcher
(setsid /apache-watcher.sh &)

# Fork and background mcrcon client for web console, must run as www-data for security
(setsid runuser -u www-data -- /mcrcon-watcher.sh &)

# Call the next script to execute.
$ENTRY_POINT