#!/bin/bash


#reason of this script is that dockerfile only execute one command at the time but we need sometimes at the moment we create 
#the docker image to run more that one software for expecified configuration like when you need mysql running to chnage or create
#database for the container ...

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq -f --force-yes bigbluebutton 

rm -f /etc/nginx/sites-enabled/default
apt-get clean 
#rm -rf /tmp/* /var/tmp/*  
#rm -rf /var/lib/apt/lists/*
