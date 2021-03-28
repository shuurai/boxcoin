FROM ubuntu:16.04
COPY ./conf/lifecoin.conf /root/.lifecoin/lifecoin.conf
COPY . /lifecoin
WORKDIR /lifecoin
#shared libraries and dependencies
RUN apt update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
#BerkleyDB for wallet support
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev
#upnp
RUN apt-get install -y libminiupnpc-dev
#ZMQ
RUN apt-get install -y libzmq3-dev
#build lifecoin source
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install
#open service port
EXPOSE 9777
CMD ["lifecoind", "--printtoconsole", "--datadir=/root/data", "--conf=/root/lifecoin.conf"]
