FROM ubuntu:20.04

ENV TZ=Asia/Tokyo

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN apt update && \
    apt install -y --no-install-recommends wget build-essential \
        libuv1-dev libcap-dev pkg-config python3 python3-pip \
        libssl-dev

RUN pip3 install ply

COPY ./configs /etc/bind

WORKDIR /work

RUN wget https://downloads.isc.org/isc/bind9/9.16.26/bind-9.16.26.tar.xz && \
    tar xf bind-9.16.26.tar.xz && \
    cd bind-9.16.26 && \
    ./configure && \
    make -j$(nproc) install && \
    rndc-confgen -a -c /etc/bind/rndc.key && \
    mkdir -p /var/run/named /var/cache/bind && \
    chown -R root:root /etc/bind /var/run/named && \
    chown -R root:root /var/cache/bind && \
    chmod -R 770 /etc/bind /var/cache/bind /var/run/named && \
    find /etc/bind /var/cache/bind -type f -exec chmod 640 -- {} +

CMD ["named", "-c", "/etc/bind/named.conf", "-g"]
