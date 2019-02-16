# Knockd
[![Build Status](https://travis-ci.org/aristarkh87/docker-knockd.svg?branch=master)](https://travis-ci.org/aristarkh87/docker-knockd)

Knockd is a port-knock server. It listens to all traffic on an ethernet (or PPP) interface, looking for special "knock" sequences of port-hits. A client makes these port-hits by sending a TCP (or UDP) packet to a port on the server. This port need not be open -- since knockd listens at the link-layer level, it sees all traffic even if it's destined for a closed port. When the server detects a specific sequence of port-hits, it runs a command defined in its configuration file. This can be used to open up holes in a firewall for quick access.

## Quick Start

```
docker run -v "$(pwd)/knockd.conf":/etc/knockd.conf -d --network host --privileged aristarkh87/docker-knockd/knockd
docker run -v "$(pwd)/conf.d":/etc/nginx/conf.d -v "$(pwd)/www:/var/www/html/" -d -p 80:80 -p $knockd_ports aristarkh87/docker-knockd/nginx
```

## Up and running

```
$ bash setup.sh
$ docker-compose up -d

$ curl -L "https://$hostname/$url_path"
```
