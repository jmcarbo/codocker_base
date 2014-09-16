build:
	docker build -t jmcarbo/codocker_base .

run:
	docker run --rm -ti --dns 127.0.0.1 -e CONSUL_OPTIONS=-server jmcarbo/codocker_base /sbin/my_init -- bash -l

push:
	docker push jmcarbo/codocker_base
