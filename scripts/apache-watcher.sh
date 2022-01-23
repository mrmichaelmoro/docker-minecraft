#!/bin/bash

# Script monitors and restarts httpd/Apache2 if the process stops running

# Apache Process Name for health check
APACHE_SVR_PROC="apache"

# Pre-reqs
OS=`cat /etc/*-release | grep "^ID=" | cut -f2 -d"=" | sed s/\"//g`

case $OS in
	ubuntu) a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests
			APACHE_CMD="/etc/init.d/apache2 start" ;;
	*) APACHE_CMD="/usr/sbin/httpd" ;;

esac

# Naive check runs checks once a minute to see if the process has exited.
# Otherwise it loops forever, waking up every 10 seconds

while sleep 10; do
  ps aux |grep $APACHE_SVR_PROC |grep -q -v grep
  PROCESS_STATUS=$?

  if [ $PROCESS_STATUS -ne 0 ]; then
    echo "[apache-watcher]: Console Webserver not running. Restarting..."
    $APACHE_CMD    
  fi
done