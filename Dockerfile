FROM docker:dind

ENV CONSUL_URL https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip
ENV NOMAD_URL https://releases.hashicorp.com/nomad/0.3.0/nomad_0.3.0_linux_amd64.zip

RUN apk update && \
    apk add python s6 dnsmasq && \
    cd /tmp && \
    curl -SsLO $CONSUL_URL && \
    curl -SsLO $NOMAD_URL && \
    unzip -d /usr/local/bin consul*.zip && \
    unzip -d /usr/local/bin nomad*.zip && \
    ln -s /lib /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

ADD s6 /etc/s6
ADD dnsmasq.d /etc/dnsmasq.d

EXPOSE 4646

CMD ["s6-svscan", "/etc/s6/"]
