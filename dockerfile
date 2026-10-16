FROM ubuntu:26.04

# pebble ships with the base image and is unused
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        lib32gcc-s1 \
        libstdc++6 \
        libvorbisfile3 \
    && rm -rf /var/lib/apt/lists/* /usr/bin/pebble

# Ubuntu images ship an "ubuntu" user with UID/GID 1000
RUN userdel -r ubuntu 2>/dev/null || true

RUN groupadd -g 1000 starbound \
    && useradd -m -u 1000 starbound -g starbound

RUN mkdir -p /starbound /steamcmd

ADD install.sh /steamcmd/install.sh

RUN chown -R starbound:starbound /starbound /steamcmd \
    && chmod u+x /steamcmd/install.sh

VOLUME ["/starbound"]

USER starbound:starbound

RUN cd /steamcmd \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -zxvf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz \
    && chmod u+x ./steamcmd.sh

ENTRYPOINT ["/steamcmd/install.sh"]
