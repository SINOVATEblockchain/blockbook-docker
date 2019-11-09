FROM debian:9

MAINTAINER crptec.fr@gmail.com

ENV TAG=master

# Install dependencies 
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential git wget pkg-config lxc-dev libzmq3-dev \
                       libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev \
                       liblz4-dev graphviz && \
    apt-get clean

ENV GOLANG_VERSION=go1.10.3.linux-amd64
ENV ROCKSDB_VERSION=v5.18.3

USER root

ENV HOME=/root
ENV GOPATH=$HOME/go
ENV PATH="$PATH:$GOPATH/bin"

# Install go
RUN cd /opt && wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz && \
    tar xf go1.10.3.linux-amd64.tar.gz
RUN ln -s /opt/go/bin/go /usr/bin/go
RUN echo -n "GO version: " && go version
RUN echo -n "GOPATH: " && echo $GOPATH

# Install go dep
RUN go get github.com/golang/dep/cmd/dep

# Install RocksDB and the Go wrapper
RUN cd $HOME && git clone https://github.com/facebook/rocksdb.git && cd rocksdb && CFLAGS=-fPIC CXXFLAGS=-fPIC make release

ENV CGO_CFLAGS="-I/$HOME/rocksdb/include"
ENV CGO_LDFLAGS="-L/$HOME/rocksdb -ldl -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4"

# Install Blockbook
RUN cd $GOPATH/src && git clone https://github.com/SINOVATEblockchain/blockbook.git && cd blockbook && git checkout $TAG && dep ensure -vendor-only && \
         BUILDTIME=$(date --iso-8601=seconds); GITCOMMIT=$(git describe --always --dirty); \ 
         LDFLAGS="-X blockbook/common.version=${TAG} -X blockbook/common.gitcommit=${GITCOMMIT} -X blockbook/common.buildtime=${BUILDTIME}" && \ 
         go build -ldflags="-s -w ${LDFLAGS}" 
RUN rm -Rf /go/pkg/dep/sources
 
# Copy startup scripts
COPY launch.sh $HOME

COPY blockchaincfg.json $HOME

EXPOSE 9099 9199

ENTRYPOINT $HOME/launch.sh
