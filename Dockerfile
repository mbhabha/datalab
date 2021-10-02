FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive

RUN ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    git \
	firefox \
	curl \
	wget \
    mc \
    vim \
	python3 \
	python3-pip \
	libreoffice \
	ipython3 \
	tigervnc-standalone-server \
	ubuntu-desktop \
    tigervnc-common \
	python-numpy \
    xfce4 xfce4-goodies \
    gdebi \
    lxde \
	r-base-core \
	ca-certificates \
    supervisor && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/novnc/noVNC /noVNC && \
    git -C /noVNC checkout -b local 36bfcb0 && \
    echo "<meta http-equiv='refresh' content='0; url=vnc.html?password=password&resize=remote&autoconnect=1'>" > /noVNC/index.html && \
    git clone https://github.com/novnc/websockify /noVNC/utils/websockify && \
    git -C /noVNC/utils/websockify checkout -b local f0bdb0a && \
    rm -rf /noVNC/.git /noVNC/utils/websockify/.git
	
WORKDIR /root/Desktop/data
WORKDIR /root/Desktop/data/import
WORKDIR	/root/Desktop/data/export
RUN chmod +x /root/Desktop/data	
	

ADD https://dl.min.io/server/minio/release/linux-amd64/minio /opt/	
RUN cd /opt
RUN chmod +x /opt/minio

COPY README.txt /root/Desktop/
COPY README.md /root/Desktop/data/export/
COPY CHANGELOG.md /root/Desktop/data/export/
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY ./desktop/*.* /root/Desktop/
COPY requirements.txt /root/Desktop/
COPY desktop-background /etc/alternatives/
COPY *.sh /opt/
RUN chmod +x /opt/*.*

ADD https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.4.1106-amd64.deb /opt/
 

ENV USER root


EXPOSE 6080

RUN mkdir /root/.vnc && \
    echo password | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    touch /root/.Xauthority && \
	update-alternatives --remove-all vncconfig
	
	

CMD ["/usr/bin/supervisord","-n"]
