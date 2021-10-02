#!/bin/bash
#install Time Zone +Update system + update pip
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
apt update
apt upgrade -y
apt install libreoffice -y
apt install python3-pip python3-dev -y
apt install python3-venv -y
python3 -m venv dev-env -y
source dev-env/bin/activate -y
pip3 install -U pip
pip3 install -U setuptools
#Jupiter NoteBook
mkdir /opt/Code
cd /opt/Code
pip3 install virtualenv
virtualenv Code
source Code/bin/activate
pip3 install jupyter

#RStudio
apt install gdebi -y
apt update
apt list --upgradable 
apt install
apt install libclang-dev -y
apt install libpq5 -y
cd /opt/
chmod +x *.deb
apt install /opt/rstudio-1.4.1106-amd64.deb -y
chown _apt /var/lib/update-notifier/package-data-downloads/partial/
apt install /opt/rstudio-1.4.1106-amd64.deb -y

#install libs python
sh /opt/requirements.sh