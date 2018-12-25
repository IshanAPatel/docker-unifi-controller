FROM ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="github.com/ishanapatel"

# package versions
ARG UNIFI_VER="5.9.29-11384-1"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
 apt-get update && \
 apt-get install --assume-yes gnupg wget && \
 echo "**** add mongo repository ****" && \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
 echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
 apt-get update && \
 echo "**** install unifi ****" && \
 echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list && \
 wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ubnt.com/unifi/unifi-repo.gpg && \
 apt-get update && \
 apt-get install --assume-yes unifi=${UNIFI_VER} && \
 echo "**** cleanup ****" && \
 apt-get autoremove --assume-yes && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# Volumes and Ports
WORKDIR /usr/lib/unifi
VOLUME /config
EXPOSE 8080 8081 8443 8843 8880