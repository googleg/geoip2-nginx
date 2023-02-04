# geoip2-nginx
Building up on this excellent work to base the image on *nginx:alpine* and adding *letsencrypt* packages 

The GeoIP DB is supposed to be on the docker host and mapped as follows:

 -v /var/lib/GeoIP/:/var/lib/GeoIP/
