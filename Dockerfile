FROM jgoerzen/supervisor:stretch
MAINTAINER John Goerzen <jgoerzen@complete.org>
RUN apt-get update && \
    apt-get -y -u dist-upgrade && \
    apt-get -y install wget \
            vim-tiny less ca-certificates \
            zip unzip telnet nano \
            inetutils-telnetd openbsd-inetd \
             && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY scripts/ /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY setup/ /tmp/setup/
RUN /tmp/setup/setup.sh && rm -r /tmp/setup

EXPOSE 5901
CMD ["/usr/local/bin/boot-supervisord"]

