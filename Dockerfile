FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive

RUN ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    locales \
    build-essential \
    git \
    telnet \
    iputils-ping \
    htop \
	firefox \
	curl \
	wget \
    mc \
    vim \
    gnome-tweak-tool \
    evince \
	python3 \
	python3-pip \
    python3-dev \
    python3-venv \
	libreoffice \
	ipython3 \
    gdebi \
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
# LOCALE
RUN sed -i '/ru_RU.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG ru_RU.UTF-8  
ENV LANGUAGE ru_RU:en  
ENV LC_ALL ru_RU.UTF-8    
# Python

#RUN python3 -m venv dev-env -y
#RUN source dev-env/bin/activate -y
RUN pip3  install -U pip
RUN pip3 install -U setuptools

# Jupyter
RUN mkdir /opt/Code
RUN cd /opt/Code
WORKDIR /opt/Code
#RUN source Code/bin/activate
RUN pip3 install virtualenv
RUN virtualenv Code

RUN pip3 uninstall ipython -y
RUN pip3 uninstall prompt_toolkit -y
RUN pip3 uninstall jupyter -y
RUN pip3 uninstall notebook -y
#Install Jupyternotebook
RUN pip3 install jupyter
RUN pip3 install notebook
RUN pip3 install ipython
RUN pip3 install prompt_toolkit 

# install Enveronment
RUN pip3 install appdirs && pip3 install argon2-cffi && pip3 install attrs
RUN pip3 install backcall && pip3 install backports.entry-points-selectable && pip3 install bleach
RUN pip3 install beautifulsoup4
RUN pip3 install catboost && pip3 install certifi && pip3 install cffi && pip3 install chardet
RUN pip3 install click && pip3 install colorama && pip3 install cupshelpers && pip3 install cycler
RUN pip3 install defusedxml && pip3 install distlib
RUN pip3 install et-xmlfile && pip3 install filelock && pip3 install graphviz && pip3 install httplib2
RUN pip3 install idna && pip3 install importlib-metadata && pip3 install importlib-resources
RUN pip3 install jedi && pip3 install ipywidgets && pip3 install jinja2 && pip3 install joblib && pip3 install jsonschema
RUN pip3 install kiwisolver && pip3 install feature-engine
RUN pip3 install language-selector && pip3 install lightgbm
RUN pip3 install matplotlib && pip3 install mistune
RUN pip3 install nbclient && pip3 install nbconvert && pip3 install nbformat && pip3 install nest-asyncio && pip3 install numpy
RUN pip3 install openpyxl
RUN pip3 install packaging && pip3 install psutil
RUN pip3 install -U pandas
RUN pip3 install pandocfilters
RUN pip3 install parso
RUN pip3 install pickle5
RUN pip3 install pickleshare
RUN pip3 install Pillow
RUN pip3 install platformdirs
RUN pip3 install plotly
RUN pip3 install ptyprocess
RUN pip3 install pycairo
RUN pip3 install pycups
RUN pip3 install Pygments
RUN pip3 install PyGObject
RUN pip3 install PyYAML
RUN pip3 install pyzmq
RUN pip3 install pandas-profiling --ignore-installed PyYAML
RUN pip3 install requests
RUN pip3 install requests-unixsocket
RUN pip3 install retrying
RUN pip3 install scikit-learn
RUN pip3 install scipy
RUN pip3 install simplegeneric
RUN pip3 install six && pip3 install soupsieve && pip3 install statsmodels && pip3 install scorecardpy && pip3 install snap && pip3 install seaborn
RUN pip3 install tenacity && pip3 install terminado && pip3 install testpath && pip3 install threadpoolctl && pip3 install tornado && pip3 install traitlets
RUN pip3 install urllib3 && pip3 install wcwidth
RUN pip3 install webencodings && pip3 install wheel && pip3 install widgetsnbextension
RUN pip3 install xlrd && pip3 install zipp && pip3 install xgboost

ENV NODE_OPTIONS="--max-old-space-size=32768"
ENV NODE_VERSION=10.18.0
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN git clone https://github.com/novnc/noVNC /noVNC && \
    git -C /noVNC checkout -b local 36bfcb0 && \
    echo "<meta http-equiv='refresh' content='0; url=vnc.html?password=password&resize=remote&autoconnect=1'>" > /noVNC/index.html && \
    git clone https://github.com/novnc/websockify /noVNC/utils/websockify && \
    git -C /noVNC/utils/websockify checkout -b local f0bdb0a && \
    rm -rf /noVNC/.git /noVNC/utils/websockify/.git
	
WORKDIR /root/Desktop/data
WORKDIR	/root/Desktop/data/samples
WORKDIR /root/Desktop/data/import
WORKDIR	/root/Desktop/data/export
RUN chmod +x /root/Desktop/data
WORKDIR /root/Desktop
COPY ./desktop/*.* /root/Desktop/

#RUN unzip gold-record-find-master.zip
WORKDIR /root/Desktop/
RUN npm i -g @aggregion/gold-record-find@latest
RUN ln -s /root/.nvm/versions/node/v10.18.0/lib/node_modules/@aggregion/gold-record-find /root/Desktop

# Pycharm & minio
ADD http://alfa.dmp.aggregion.com/pycharm-community-2021.2.3.tar.gz /opt/
ADD https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20220128022816.0.0_amd64.deb /opt/
WORKDIR /opt
RUN tar -xzf /opt/pycharm-community-2021.2.3.tar.gz	
RUN chmod +x /opt/minio
RUN ln -s /opt/pycharm-community-2021.2.3/bin/pycharm.sh /usr/local/bin/pycharm

COPY README.md /root/Desktop/data/export/
COPY CHANGELOG.md /root/Desktop/data/export/
COPY gbm-data.csv /root/Desktop/data/samples/
COPY Model.ipynb /root/Desktop/data/samples/
COPY Model_2.ipynb /root/Desktop/data/samples/
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY desktop-background /etc/alternatives/
COPY pip.conf /etc/

COPY *.sh /opt/
RUN chmod +x /opt/*.*

# R Setup
ADD https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.4.1106-amd64.deb /opt/
WORKDIR /opt/
#RUN chmod +x *.deb
RUN apt-get update -y
RUN apt-get install -y 
RUN	apt install libclang-dev -y  
RUN	apt install libpq5 -y 
RUN	apt install /opt/rstudio-1.4.1106-amd64.deb -y 
RUN	chown _apt /var/lib/update-notifier/package-data-downloads/partial/
RUN apt install /opt/rstudio-1.4.1106-amd64.deb -y	

ENV USER root

EXPOSE 6080

RUN mkdir /root/.vnc && \
    echo password | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd && \
    touch /root/.Xauthority && \
	update-alternatives --remove-all vncconfig

CMD ["/usr/bin/supervisord","-n"]
