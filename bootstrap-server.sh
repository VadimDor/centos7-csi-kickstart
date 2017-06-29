#!bin/sh
sudo yum install -y wget
# or wget goo.gl/MKqJsX -O  prepare-grub.sh
wget  https://raw.githubusercontent.com/VadimDor/centos7-csi-kickstart/master/prepare-grub.sh -O  /boot/prepare-grub.sh
wget  https://raw.githubusercontent.com/VadimDor/centos7-csi-kickstart/master/config/hardening/hardened-centos.cfg -O  /boot/hardened-centos.cfg
wget  https://raw.githubusercontent.com/VadimDor/centos7-csi-kickstart/master/ask-config.sh -O  /boot/ask-config.sh
wget  https://raw.githubusercontent.com/VadimDor/centos7-csi-kickstart/master/prepare-grub.sh -O  /boot/prepare-grub.sh
