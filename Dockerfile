FROM phusion/baseimage:0.9.13
MAINTAINER Joan Marc Carbo Arnau <jmcarbo@gmail.com>

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

RUN apt-get update && apt-get -y install wget curl unzip

ADD https://dl.bintray.com/mitchellh/consul/0.4.0_linux_amd64.zip /tmp/consul.zip
RUN cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && rm /tmp/consul.zip

ADD https://dl.bintray.com/mitchellh/consul/0.4.0_web_ui.zip /tmp/webui.zip
RUN cd /tmp && unzip /tmp/webui.zip && mv dist /ui && rm /tmp/webui.zip

ADD ./config /config/

RUN wget -nc -q -O consul.zip https://dl.bintray.com/mitchellh/consul/0.4.0_linux_amd64.zip && unzip -o -q consul.zip && rm consul.zip && install consul /usr/bin
ADD https://github.com/jmcarbo/codns/raw/master/bin/codns_linux_amd64 /bin/codns
ADD https://github.com/jmcarbo/consul_servant/raw/master/bin/consul_servant_linux_amd64 /bin/consul_servant
ADD https://github.com/jmcarbo/consul_servant/raw/master/bin/consul_visa_linux_amd64 /bin/consul_visa
RUN chmod +x /bin/consul_servant /bin/consul_visa /bin/codns

RUN mkdir /etc/service/consul
ADD run_consul /etc/service/consul/run
RUN chmod +x /etc/service/consul/run

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp
VOLUME ["/data", "/config"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
