FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update 
RUN apt-get install -y dialog apt-utils
RUN	apt-get -y upgrade

RUN	apt-get install -y sudo \
		debconf \
		wget\
		nano
RUN	sudo apt-get install -y  \
		bind9 \
		bind9utils \
		bind9-doc

RUN echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get update && apt-get install -y wget locales nano ntpdate
RUN dpkg-reconfigure locales

# Add the following Repositories 
RUN echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
RUN echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list

# Fetch and install the GPG key:
RUN sudo wget http://www.webmin.com/jcameron-key.asc
RUN sudo apt-key add jcameron-key.asc

# Install & Wetup Webmin
RUN apt-get update
RUN apt-get install -y wget nano curl git
RUN apt-get install webmin -y && apt-get autoclean

# Create "Zones" directory for BIND9
RUN mkdir /etc/bind/zones

# Copr the startup Script to Root Directory
COPY entrypoint.sh /entrypoint.sh

# Giving executable permissions for teh startup script
RUN chmod +x /entrypoint.sh

VOLUME ["/etc/webmin"]
VOLUME ["/etc/bind"]

# Expose ports to other containers
EXPOSE 10000 53

# Set "root" user password for Webmin
RUN echo "root:Docker!" | chpasswd

# Set the entrypoint for the container
ENTRYPOINT ["./entrypoint.sh"]