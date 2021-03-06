FROM docker:dind

ENV CONSUL_URL https://releases.hashicorp.com/consul/0.9.0/consul_0.9.0_linux_amd64.zip
ENV NOMAD_URL https://releases.hashicorp.com/nomad/0.6.0/nomad_0.6.0_linux_amd64.zip
ENV CONSUL_TEMPLATE_URL https://releases.hashicorp.com/consul-template/0.19.0/consul-template_0.19.0_linux_amd64.zip

RUN apk update && \
    apk add python s6 dnsmasq nginx openssh jq curl && \
    cd /tmp && \
    curl -SsLO $CONSUL_URL && \
    curl -SsLO $NOMAD_URL && \
    curl -SsLO $CONSUL_TEMPLATE_URL && \
    unzip -d /usr/local/bin consul_*.zip && \
    unzip -d /usr/local/bin nomad_*.zip && \
    unzip -d /usr/local/bin consul-template_*.zip && \
    rm -f *.zip && \
    echo "root:changeme" | chpasswd && \
    ln -s /lib /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

ADD etc /etc
# ADD nomad-jobs /nomad-jobs
ADD var /var

EXPOSE 4646
EXPOSE 80
EXPOSE 22

CMD ["s6-svscan", "/etc/s6/"]
