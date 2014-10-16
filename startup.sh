#!/bin/bash


set -e

if [ -f /etc/configured ]; then
        #to make sure it works ..
        
        bbb-conf --check
        echo 'already configured'
else
        #code that need to run only one time ....
        #needed for fix problem with ubuntu and cron
        bbb-conf --setip $(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
        dpkg --configure -a
        bbb-conf --check
        update-locale 
        date > /etc/configured
fi
