FROM debian:stable
MAINTAINER Michael Schaefer

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y \
&& apt-get -y install wget apt-transport-https sudo dpkg perl perl-modules netcat supervisor

# Get collectord and install
RUN wget https://svn.fhem.de/trac/export/HEAD/trunk/fhem/contrib/PRESENCE/deb/collectord-1.8.1.deb && \
dpkg -i collectord-1.8.1.deb

RUN mkdir -p /var/log/supervisor && \
mkdir /etc/collectord

RUN echo Europe/Berlin > /etc/timezone && dpkg-reconfigure tzdata
COPY /etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

HEALTHCHECK --interval=10s --timeout=10s --start-period=30s --retries=3 CMD nc -z 127.0.0.1 5222 || exit 1

EXPOSE 5222
CMD ["/usr/bin/supervisord"]
