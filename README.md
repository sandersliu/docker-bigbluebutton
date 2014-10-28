docker-bigbluebutton
====================

container running bigbluebutton

 docker run -d -p 80:80 -p 9123:9123 -p 1935:1935 -p 5066:5066 angelrr7702/docker-bigbluebutton

Them you need to run this command to finish installing :

docker exec -it container_id /sbin/after_install

This will finish installation final conf and change ip conf for the container ...


note : container still fail to work ... maybe is relate that bigbluebutton is design to run over ubuntu and fail to run over a container ... the problem is that it try to modified the brownser info navigation by internal ip or external ip configuration and that will fail ... exaple :

the container will have ip for internal ... docker ... 
and one ip external plus port that docker assigne for port 80  with its relate port for the server where docker it is ruuning.... but because this appliocation try to define the ip at the brownser it will fail to get the port of the port 80 that the container its using .... and will show wrong ip ...  including fallowing the amazon conf recomendation to make it work fail .... 

In general I believe there is desing problem here .. for web application ... no idea how to call it ... but relate that application is running different services but use pre-define ip(external ip and internal) that mess with conf and navigation at the brownser ... if you try to fix one side another get broken ... 



