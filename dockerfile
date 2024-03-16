FROM ubuntu:22.04

ENV STEAM_ACCOUNT account
ENV STEAM_PASSWORD password
ENV MOD_IDS ()
ENV UID 1000
ENV GID 1000

# install dependencies
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove -y
RUN apt install software-properties-common lib32gcc-s1 libvorbisfile3 wget libstdc++6 -y

RUN groupadd -g $GID starbound \
    && useradd -u $UID starbound -g starbound

RUN mkdir -p /starbound \
    && mkdir -p /steamcmd

ADD install.sh /steamcmd/install.sh

RUN chown -R starbound:starbound /starbound \
    && chown -R starbound:starbound /steamcmd

VOLUME ["/starbound"]

USER starbound:starbound

# download and install steamcmd
RUN cd /steamcmd \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -zxvf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz \
    && chmod u+x ./steamcmd.sh

RUN chmod u+x /steamcmd/install.sh

RUN touch /steamcmd/installmods.txt

ENTRYPOINT ["steamcmd/install.sh"]
