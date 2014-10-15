#!/bin/bash


set -e

if [ -f /etc/configured ]; then
        /sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' | bbb-conf --setip 
        bbb-conf --clean
        bbb-conf --check
        echo 'already configured'
else
        #code that need to run only one time ....
        #needed for fix problem with ubuntu and cron
        update-locale 
        date > /etc/configured
fi
