FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    gcc-arm-linux-gnueabi \
    make \
    qemu-user \
    gdb-multiarch \
  && rm -rf /var/lib/apt/lists/*

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_amd64.deb /tmp/dumb-init_1.2.5_amd64.deb
RUN dpkg -i /tmp/dumb-init_*.deb

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
