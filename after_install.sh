#!/bin/bash
#take the container real ip to configured the web application 
# in some areas fail because it keep ip info where the container was build that is not the same 
#where it will run.... need to find all the wrong conf file and fix it in this area ...
ctner_intn_ip=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
#need to find external ip address of server 
#this fail to get the right ip when inside of home network ... it get the ip from router ..outside of home....
ctner_extn_ip=$(curl -s icanhazip.com)
#to configured bigbluebutton
bbb-conf --setip $ctner_intn_ip
#to change conf /etc/bigbluebutton/nginx/sip.nginx
# this fail too .....
sed -i 's/.*proxy_pass.http:.*/proxy_pass http:\/$ctner_extn_ip\/:5066;/' /etc/bigbluebutton/nginx/sip.nginx
#to change conf /opt/freeswitch/conf/vars.xml
sed -i 's/.*data="local_ip_v4.*/ /' /opt/freeswitch/conf/vars.xml
sed -i 's/.*data="bind_server_ip.*/<X-PRE-PROCESS cmd="set" data="bind_server_ip='$ctner_extn_ip'"\/>/' /opt/freeswitch/conf/vars.xml
sed -i 's/.*data="external_rtp_ip.*/<X-PRE-PROCESS cmd="set" data="external_rtp_ip='$ctner_extn_ip'"\/>/' /opt/freeswitch/conf/vars.xml
sed -i 's/.*data="external_sip_ip.*/<X-PRE-PROCESS cmd="set" data="external_sip_ip='$ctner_extn_ip'"\/>/' /opt/freeswitch/conf/vars.xml
#to change conf /opt/freeswitch/conf/sip_profiles/external.xml
#this fail
sed -i 's/.*name="rtp-ip" value.*/<param name="rtp-ip" value="'$ctner_intn_ip'"/>/' /opt/freeswitch/conf/sip_profiles/external.xml
sed -i 's/.*name="sip-ip" value.*/<param name="sip-ip" value="'$ctner_intn_ip'"/>/' /opt/freeswitch/conf/sip_profiles/external.xml
sed -i 's/.*name="ext-rtp-ip" value.*/<param name="ext-rtp-ip" value="'$ctner_extn_ip'"/>/' /opt/freeswitch/conf/sip_profiles/external.xml
sed -i 's/.*name="ext-sip-ip" value.*/<param name="ext-sip-ip" value="'$ctner_extn_ip'"/>/' /opt/freeswitch/conf/sip_profiles/external.xml
#to change conf /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties
sed -i 's/.*bbb.sip.app.ip=.*/bbb.sip.app.ip=$ctner_intn_ip/' /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties
sed -i 's/.*freeswitch.ip=.*/freeswitch.ip=$ctner_intn_ip/' /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties
#to change /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp
sed -i 's/.*String.BigBlueButtonURL.*/String BigBlueButtonURL = "http:\/\/'$ctner_extn_ip'\/bigbluebutton\/";/' /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp
#to change /etc/nginx/sites-available/bigbluebutton
#this maybe if the port will no be the same ...
#Open the firewall (if you have on installed) and Security Groups the following ports:
#TCP - 5066
#UDP - 16384 to 32768
