FROM alpine

RUN apk add --no-cache openssl easy-rsa openvpn iptables bash

RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 
