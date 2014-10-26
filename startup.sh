#!/bin/bash


set -e

if [ -f /etc/configured ]; then
        #to make sure it works ..
        
        #bbb-conf --check
        echo 'already configured'
else
        #code that need to run only one time ....
        #to finish install that fail when container image was created 
        #container build image try to create the configuration but it is the wrong enviroment ... 
        # but after it is create or run the first time is the best for it to finish it
        source /root/.bashrc
        #this fail under this eviurement but work fine under bash
        dpkg --configure -a
        apt-get install bbb-demo
       
        
        #run the script to change ip
        /sbin/after_install

        #to find any error relate to the container configuration for future fix
        bbb-conf --check  >>/var/log/bbb-conf.log 2>&1
        
        #needed for fix problem with ubuntu and cron
        update-locale 
        date > /etc/configured
fi
