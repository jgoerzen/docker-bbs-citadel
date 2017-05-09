FROM jgoerzen/supervisor:stretch
MAINTAINER John Goerzen <jgoerzen@complete.org>
RUN apt-get update && \
    apt-get -y -u dist-upgrade && \
    apt-get -y --no-install-recommends install wget \
            vim-tiny less ca-certificates \
            zip unzip telnet nano procps net-tools \
            inetutils-telnetd openbsd-inetd debconf-utils && \
            apt-get clean
COPY debconf-selections /tmp/
# The initial configuration requires that citserver
# be running.  invoke-rc.d prevents this, thus preventing
# configuration from taking hold.
RUN debconf-set-selections /tmp/debconf-selections && \
    mv -vi /usr/sbin/invoke-rc.d /usr/sbin/invoke-rc.d.temp && \
    apt-get -y --install-recommends install citadel-server && \
    ( /etc/init.d/citadel stop || true ) && \
    mv -vi /usr/sbin/invoke-rc.d.tmp /usr/sbin/invoke-rc.d && \
    apt-get -y install citadel-suite && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY scripts/ /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY setup/ /tmp/setup/
RUN /tmp/setup/setup.sh && rm -r /tmp/setup

EXPOSE 5901
CMD ["/usr/local/bin/boot-supervisord"]

