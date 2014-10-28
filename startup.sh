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
       
        #needed for fix problem with ubuntu and cron
        update-locale 
        date > /etc/configured
fi
