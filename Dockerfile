FROM debian:jessie
MAINTAINER Michael Hammer <mail@michael-hammer.at>

# update apt and install dependencies
RUN apt-get -qq update
RUN apt-get -y install git-core wget build-essential debhelper cdbs autotools-dev autoconf automake libtool pkg-config base-files debianutils libsystemd-dev libsystemd-daemon-dev base-files
RUN apt-get -y install libusb-1.0-0-dev dh-systemd init-system-helpers
Run apt-get clean

ENV SOURCE_DIR /usr/local/src
WORKDIR $SOURCE_DIR

# ENV LD_LIBRARY_PATH $INSTALLDIR/lib
ENV EIBD_iptn 192.168.250.5
ENV EIBD_eibaddr 15.15.1

RUN wget https://www.auto.tuwien.ac.at/~mkoegler/pth/pthsem_2.0.8.tar.gz
RUN tar -xzf pthsem_2.0.8.tar.gz
RUN cd pthsem-2.0.8 && dpkg-buildpackage -b -uc
RUN dpkg -i libpthsem*.deb

RUN git clone https://github.com/knxd/knxd.git
RUN cd knxd && dpkg-buildpackage -b -uc
RUN dpkg -i knxd_*.deb knxd-tools_*.deb

RUN apt-get -y purge git-core wget build-essential debhelper cdbs automake autoconf libtool pkg-config
RUN apt-get -y autoremove

EXPOSE 6720
