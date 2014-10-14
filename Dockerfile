#name of container: docker-bigbluebutton
#versison of container: 0.5.1
FROM quantumobject/docker-baseimage
MAINTAINER Angel Rodriguez  "angel@quantumobject.com"

# Set correct environment variables.
ENV HOME /root
RUN update-locale LANG=en_US.UTF-8

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list \
    && wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add - \
    && echo "deb http://ubuntu.bigbluebutton.org/trusty-090/ bigbluebutton-trusty main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y -q build-essential \
                              git-core \
                              checkinstall \
                              yasm \
                              texi2html \
                              libvorbis-dev \
                              libx11-dev \
                              libvpx-dev \
                              libxfixes-dev \
                              zlib1g-dev \
                              pkg-config \
                              netcat \
                    && apt-get clean \
                    && rm -rf /tmp/* /var/tmp/*  \
                    && rm -rf /var/lib/apt/lists/*

#install ffmpeg
copy ffmpeg.sh /tmp/ffmpeg.sh
RUN chmod +x /tmp/ffmpeg.sh \
    && /bin/bash -c /tmp/ffmpeg.sh \
    && rm /tmp/ffmpeg.sh
    
#General variable definition....

##startup scripts  
#Pre-config scrip that maybe need to be run one time only when the container run the first time .. using a flag to don't 
#run it again ... use for conf for service ... when run the first time ...
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh


##Adding Deamons to containers

#pre-config scritp for different service that need to be run when container image is create 
#maybe include additional software that need to be installed ... with some service running ... like example mysqld
COPY pre-conf.sh /sbin/pre-conf
RUN chmod +x /sbin/pre-conf \
    && /bin/bash -c /sbin/pre-conf \
    && rm /sbin/pre-conf

##scritp that can be running from the outside using docker-bash tool ...
## for example to create backup for database with convitation of VOLUME   dockers-bash container_ID backup_mysql
COPY backup.sh /sbin/backup
RUN chmod +x /sbin/backup
VOLUME /var/backups


#add files and script that need to be use for this container
#include conf file relate to service/daemon 
#additionsl tools to be use internally 

# to allow access from outside of the container  to the container service
# at that ports need to allow access from firewall if need to access it outside of the server. 
EXPOSE #ports

#creatian of volume 
#VOLUME 

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
