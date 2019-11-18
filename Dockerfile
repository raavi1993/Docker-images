FROM ubuntu:18.04 
MAINTAINER Vikash RAAVI

RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list; 

RUN echo "America/Chicago" > /etc/timezone

# RUN sudo ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime

RUN apt-get update -q && apt-get install -y --no-install-recommends apt-utils && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends tzdata

RUN dpkg-reconfigure -f noninteractive tzdata

# Install packages
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends wget curl rsync netcat mg vim bzip2 zip unzip && \
    apt-get install -y --no-install-recommends libx11-6 libxcb1 libxau6 && \
    apt-get install -y --no-install-recommends lubuntu-desktop && \
    apt-get install -y --no-install-recommends lxde tightvncserver xvfb dbus-x11 x11-utils && \
    apt-get install -y --no-install-recommends xfonts-base xfonts-75dpi xfonts-100dpi && \
    apt-get install -y --no-install-recommends python-pip python-dev python-qt4 && \
    apt-get install -y --no-install-recommends libssl-dev && \
    apt-get install -y --no-install-recommends git && \
    apt-get install -y --no-install-recommends openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /root/

RUN mkdir -p /root/.vnc
COPY xstartup /root/.vnc/
RUN chmod a+x /root/.vnc/xstartup
RUN touch /root/.vnc/passwd
RUN echo PSD FOR VNC SERVER | vncpasswd -f > /root/.vnc/passwd
RUN chmod 400 /root/.vnc/passwd
RUN chmod go-rwx /root/.vnc
RUN touch /root/.Xauthority

COPY start-vncserver.sh /root/
RUN chmod a+x /root/start-vncserver.sh

RUN echo "YOUR IMAGE NAME" > /etc/hostname
RUN echo "127.0.0.1	localhost" > /etc/hosts
RUN echo "127.0.0.1	yOUR IMAGE NAME"  >> /etc/hosts

EXPOSE 5901
ENV USER root
CMD [ "/root/start-vncserver.sh" ]
