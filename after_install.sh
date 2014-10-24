#!/bin/bash

#to finish install that fail when container image was created 
#container build image try to create the configuration but it is the wrong enviroment ... 
# but after it is create or run the first time is the best for it to finish it
dpkg --configure -a

#take the container real ip to configured the web application 
# in some areas fail because it keep ip info where the container was build that is not the same 
#where it will run.... need to find all the wrong conf file and fix it in this area ...
bbb-conf --setip $(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

#to find any error relate to the container configuration for future fix
bbb-conf --check  >>/var/log/bbb-conf.log 2>&1

#start it with all the service ... maybe is no the right place to do it but at runit script ..
bbb-conf --start


