docker-bigbluebutton
====================

container running bigbluebutton

 docker run -d -p 80:80 -p 9123:9123 -p 1935:1935 -p 5066:5066 angelrr7702/docker-bigbluebutton

Them you need to run this command to finish installing :

docker exec -it container_id /sbin/after_install

This will finish installation final conf and change ip conf for the container ...

