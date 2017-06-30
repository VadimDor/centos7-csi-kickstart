#!bin/sh

# Check for root user
if [[ $EUID -ne 0 ]]; then
tput setaf 1;echo -e "\033[1mPlease re-run this script as root!\033[0m";tput sgr0
exit 1
yum install -y wget
# or wget goo.gl/MKqJsX -O  prepare-grub.sh
wget  https://raw.githubusercontent.com/VadimDor/centos7-csi-kickstart/master/prepare-grub.sh -O  /boot/prepare-grub.sh
chmod +x /boot/prepare-grub.sh
wget  https://raw.githubusercontent.com/VadimDor/hardened-centos7-kickstart/master/config/hardening/hardened-centos.cfg -O  /boot/hardened-centos.cfg
wget  https://raw.githubusercontent.com/VadimDor/centos7-csi-kickstart/master/ask-config.sh -O  /boot/ask-config.sh
chmod +x /boot/ask-config.sh
wget  https://raw.githubusercontent.com/VadimDor/hardened-centos7-kickstart/master/config/hardening/supplemental.cfg -O  /boot/supplemental.sh
chmod +x /boot/supplemental.sh
wget  https://raw.githubusercontent.com/VadimDor/hardened-centos7-kickstart/master/config/hardening/fips-kernel-mode.sh -O  /root/hardening/fips-kernel-mode.sh
chmod +x /boot/fips-kernel-mode.sh
wget  https://raw.githubusercontent.com/VadimDor/hardened-centos7-kickstart/master/config/hardening/scap-security-guide-0.1.33-Linux-content.rpm -O  /root/hardening/scap-security-guide-0.1.33-Linux-content.rpm
