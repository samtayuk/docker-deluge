FROM ubuntu:14.04
MAINTAINER Samuel Taylor "samtaylor.uk@gmail.com"

# Version
ENV DELUGE_VERSION 1.3.11-0~trusty~ppa1

# Default user and password
ENV DELUGE_USER deluge
ENV DELUGE_PASSWORD deluge

# To get rid of error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 249AD24C \
  && echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" | tee -a /etc/apt/sources.list \
  && echo "deb http://ppa.launchpad.net/deluge-team/ppa/ubuntu trusty main" | tee -a /etc/apt/sources.list \
  && apt-get update -q \
  && apt-get install -qy deluged=$DELUGE_VERSION deluge-web=$DELUGE_VERSION unrar unzip p7zip wget \
  && apt-get autoremove -qy \
  ; apt-get clean \
  ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

 # Install Forego
RUN wget -P /usr/local/bin https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego \
  && chmod u+x /usr/local/bin/forego

VOLUME ["/config", "/data/downloads"]

EXPOSE 53160 53160/udp 8112 58846

COPY . /app
RUN chmod +x /app/entrypoint.sh

WORKDIR /app/

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["forego", "start", "-r"]
