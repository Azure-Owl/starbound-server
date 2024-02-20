FROM ubuntu:22.04

ENV STEAM_ACCOUNT account
ENV STEAM_PASSWORD password
ENV MOD_IDS ()

# install dependencies
RUN apt update
RUN apt install software-properties-common lib32gcc-s1 libvorbisfile3 wget -y

RUN mkdir -p /starbound

VOLUME ["/starbound"]

# download and install steamcmd
RUN mkdir -p /steamcmd \
    && cd /steamcmd \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -zxvf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz \
    && chmod +x ./steamcmd.sh

ADD install.sh /install.sh

RUN chmod +x /install.sh

RUN touch /steamcmd/installmods.txt

ENTRYPOINT ["./install.sh"]
