FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y           \
       clang                     \
       gcc                       \
       g++                       \
       g++-multilib              \
       gdb                       \
       clang-tidy                \
       clang-format              \
       gcovr                     \
       llvm                      \
       sudo                      \
       make                      \
       cmake                     \
       git                       \
       less                      \
       wget                      \
       flex                      \
       bison                     \
       libgraphviz-dev           \
       libboost-all-dev          \
       graphviz
       
RUN apt-get install -y           \ 
       nano \
       vim
RUN     apt-get clean &&\
    rm -rf /var/cache


# This adds the 'default' user to sudoers with full privileges:
RUN HOME=/home/default && \
    mkdir -p ${HOME} && \
    GROUP_ID=1000 && \
    USER_ID=1000 && \
    groupadd -r default -f -g "$GROUP_ID" && \
    useradd -u "$USER_ID" -r -g default -d "$HOME" -s /sbin/nologin \
    -c "Default Application User" default && \
    chown -R "$USER_ID:$GROUP_ID" ${HOME} && \
    usermod -a -G sudo default && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++
ENV CCACHE_DIR=/build/docker_ccache
ENV LD_LIBRARY_PATH=/usr/local/lib

ENV CUDD_VERSION="3.0.0"
ENV MONA_VERSION="1.4-19.dev0"
ENV SYFT_TAG="v0.1.1"


WORKDIR /build

# Install CUDD
RUN wget https://github.com/whitemech/cudd/releases/download/v${CUDD_VERSION}/cudd_${CUDD_VERSION}_linux-amd64.tar.gz &&\
    tar -xf cudd_${CUDD_VERSION}_linux-amd64.tar.gz &&\
    cd cudd_${CUDD_VERSION}_linux-amd64 &&\
    cp -P lib/* /usr/local/lib/ &&\
    cp -Pr include/* /usr/local/include/ &&\
    rm -rf cudd_${CUDD_VERSION}_linux-amd64*

# Install MONA
RUN git clone https://github.com/whitemech/MONA.git &&\
    cd MONA &&\
    sed -i '/for i in \${OUTPUT_DIR}\/lib\/\*;/,/done/d' scripts/release.sh &&\
    ./scripts/release.sh &&\
    tar -xf mona_${MONA_VERSION}_linux-amd64.tar.gz &&\
    cd mona_${MONA_VERSION}_linux-amd64 &&\
    cp -P lib/* /usr/local/lib/ &&\
    cp -Pr include/* /usr/local/include &&\
    cd .. &&\
    cd .. &&\
    rm -rf MONA

# Build and install Syft
RUN git clone https://github.com/whitemech/Syft.git &&\
    cd Syft &&\
    git checkout ${SYFT_TAG} &&\
    mkdir build && cd build &&\
    cmake -DCMAKE_BUILD_TYPE=Release .. &&\
    make -j &&\
    make install &&\
    cd .. &&\
    rm -rf Syft


WORKDIR /build/lydia

ARG GIT_REF=main

# Clone and build Lydia
RUN git clone --recursive https://github.com/whitemech/lydia.git /build/lydia
RUN git checkout ${GIT_REF} &&\
    rm -rf build &&\
    mkdir build &&\
    cd build &&\
    cmake -DCMAKE_BUILD_TYPE=Release .. &&\
    cmake --build . --target lydia-bin -j4 &&\
    make install &&\
    cd .. &&\
    rm -rf /build/lydia

WORKDIR /build

# Build and install SyftMax
RUN git clone https://github.com/Shufang-Zhu/SyftMax.git &&\
    cd SyftMax &&\
    mkdir build && cd build &&\
    cmake -DCMAKE_BUILD_TYPE=Release .. &&\
    make

RUN cp /build/SyftMax/build/bin/Syftmax /usr/local/bin/Syftmax &&\
    rm -rf /build

WORKDIR /home/default

USER default

RUN 	touch formula.ltlf && \
	touch partition.part

#ENTRYPOINT ["/usr/local/bin/Syftmax"]
