codocker_base
=============

Consul + Phusion base docker image. Take control of your containers

This Dockerfile creates a base image for docker deployment with a consul agent preinstalled.
It is heavily opinionated. It assumes you will be using weave network management and that every
docker container will be running a consul agent.

The first server should be started with:

```
weave 10.0.1.1/24 run --rm -d --dns 127.0.0.1 -e CONSUL_OPTIONS="-server -bootstrap -dc alabama" jmcarbo/codocker_base /sbin/my_init 

weave 10.0.1.2/24 run --rm -d --dns 127.0.0.1 -e CONSUL_OPTIONS="-server -dc alabama -join 10.0.1.1" jmcarbo/codocker_base /sbin/my_init 

weave 10.0.1.3/24 run --rm -d --dns 127.0.0.1 -e CONSUL_OPTIONS="-server -dc alabama -join 10.0.1.1" jmcarbo/codocker_base /sbin/my_init 
```
The rest of the nodes can be run with:

```
weave 10.0.1.4/24 run --rm -d --dns 127.0.0.1 -e CONSUL_OPTIONS="-dc alabama -join 10.0.1.1" jmcarbo/codocker_base /sbin/my_init 
```

