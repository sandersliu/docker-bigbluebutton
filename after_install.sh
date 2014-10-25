#!/bin/bash

#take the container real ip to configured the web application 
# in some areas fail because it keep ip info where the container was build that is not the same 
#where it will run.... need to find all the wrong conf file and fix it in this area ...
ctner_intn_ip=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
ctner_extn_ip=$(curl -s icanhazip.com)

bbb-conf --setip $ctner_intn_ip

#need to find external ip address of server 
#Need to fix 
#/etc/bigbluebutton/nginx/sip.nginx
# proxy_pass http://172.17.0.193:5066;   # replace line... external maybe

#need to edit and fix  /opt/freeswitch/conf/vars.xml
sed -i 's/.*data="local_ip_v4.*/ /' /opt/freeswitch/conf/vars.xml
sed -i 's/.*data="bind_server_ip.*/<X-PRE-PROCESS cmd="set" data="bind_server_ip=$ctner_extn_ip"\/>/' /opt/freeswitch/conf/vars.xml
sed -i 's/.*data="external_rtp_ip.*/<X-PRE-PROCESS cmd="set" data="external_rtp_ip=$ctner_extn_ip"\/>/' /opt/freeswitch/conf/vars.xml
sed -i 's/.*data="external_sip_ip.*/<X-PRE-PROCESS cmd="set" data="external_sip_ip=$ctner_extn_ip"\/>/' /opt/freeswitch/conf/vars.xml

Edit /opt/freeswitch/conf/sip_profiles/external.xml and change

    <param name="rtp-ip" value="$${local_ip_v4}"/>
    <param name="sip-ip" value="$${local_ip_v4}"/>
    <param name="ext-rtp-ip" value="$${local_ip_v4}"/>
    <param name="ext-sip-ip" value="$${local_ip_v4}"/>
to

    <param name="rtp-ip" value="$${local_ip_v4}"/>
    <param name="sip-ip" value="$${local_ip_v4}"/>
    <param name="ext-rtp-ip" value="$${external_rtp_ip}"/>
    <param name="ext-sip-ip" value="$${external_sip_ip}"/>
    
##########
Edit /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties

bbb.sip.app.ip=<internal ip>
bbb.sip.app.port=5070

freeswitch.ip=<internal ip>
freeswitch.port=5060

####################
/var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp
String BigBlueButtonURL = "http://199.59.90.34:49166/bigbluebutton/";  external ip:port 
#####################
/etc/nginx/sites-available/bigbluebutton   internal port ....
#####################
#Open the firewall (if you have on installed) and Security Groups (if your using EC2) the following ports:
#TCP - 5066
#UDP - 16384 to 32768
