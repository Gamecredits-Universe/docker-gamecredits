FROM ubuntu:14.04
MAINTAINER Gamecredits dr.bob@spam.com

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common git libqrencode-dev make build-essential libtool autotools-dev autoconf libssl-dev libboost-all-dev && add-apt-repository -y ppa:bitcoin/bitcoin
RUN apt-get update -y
RUN apt-get install -y libdb4.8-dev libminiupnpc-dev
RUN apt-get install -y libdb4.8++-dev
RUN apt-get install -y bsdmainutils
RUN apt-get install -y pkg-config

# Versions

# Only needed for debugging
# RUN apt-get install -y vnc4server
# RUN export DISPLAY=:33
# RUN (echo masterbob;echo masterbob)|vnc4passwd
# EXPOSE 5933

# Install stuff

# Create user.
RUN adduser docker

# Copy configuration files.
RUN mkdir -p /home/docker/.gamecredits
ADD gamecredits.conf /home/docker/.gamecredits/gamecredits.conf
RUN chmod 664 /home/docker/.gamecredits/gamecredits.conf
RUN chown -R docker:docker /home/docker

# Change user.

USER docker
WORKDIR /home/docker
ENV HOME /home/docker

RUN git clone https://github.com/gamers-coin/GameCredits

WORKDIR /home/docker/GameCredits
RUN ./autogen.sh
RUN ./configure
RUN make
RUN /home/docker/GameCredits/src/gamecreditsd


# expose two rpc ports for the nodes to allow outside container access
EXPOSE 40001 40002
CMD ["/bin/bash"]
# RUN tail -f /home/docker/.gamecredits/debug.log
