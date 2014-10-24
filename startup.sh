#!/bin/bash


set -e

if [ -f /etc/configured ]; then
        #to make sure it works ..
        
        #bbb-conf --check
        echo 'already configured'
else
        #code that need to run only one time ....
        dpkg --configure -a
        
        #run the script to change ip
        /sbin/after_install
        
        #to find any error relate to the container configuration for future fix
        bbb-conf --check  >>/var/log/bbb-conf.log 2>&1
        
        #start it with all the service ... maybe is no the right place to do it but at runit script ..
        bbb-conf --start &
        
        #needed for fix problem with ubuntu and cron
        update-locale 
        date > /etc/configured
fi
