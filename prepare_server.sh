#!/bin/sh

sudo chmod -R 777 /boot/grub2
sudo chmod -R 777  /etc/grub.d

#mkdir /centos-orig64
#cd /centos-orig64
cd /boot
yum install -y wget
wget http://centos.mirrors.ovh.net/ftp.centos.org/7/os/x86_64/images/pxeboot/initrd.img
wget http://centos.mirrors.ovh.net/ftp.centos.org/7/os/x86_64/images/pxeboot/vmlinuz
mv vmlinuz vmlinuz.cent.pxe 2>/dev/null
mv initrd.img initrd.img.cent.pxe 2>/dev/null
wget  https://github.com/VadimDor/centos7-csi-kickstart/blob/master/prepare_server.sh


#DNS : cat /etc/resolv.conf |grep -i nameserver|head -n1|cut -d ' ' -f2
# serverip:  /sbin/ifconfig eth0 | awk '/inet/{ print $2;} '|head -n1
# mask: /sbin/ifconfig eth0 | awk '/inet/{ print $4;} '|head -n1
# gateway:  route -n  | awk '/0.0.0.0/{ print $2;} '|head -n1   OR route �N | grep UG
# interface: /sbin/ifconfig -a  | awk '/BROADCAST/{ print $1;} '|head -n1|sed 's/://'
# or interface: ifconfig | grep -o '^eth[0-9]\+'
# hd(e.g. /dev/sda6 should read (hd0, 5):  fdisk -l
#server name: uname -n
#kernel: uname -r
#kernel /boot/vmlinuz.cent.pxe vnc vncpassword=pass123 headless ip=serverip netmask=255.255.255.0 gateway=gatewayip dns=8.8.8.8 ksdevice=eth0 method=http://ftp.hosteurope.de/mirror/centos.org/5/os/i386/ lang=en_US keymap=us

#cat <<. > /boot/grub2/grub.cfg
#default 0
#timeout 5
#title Centos Install (PXE)
#root (hd0,0)
#kernel /boot/vmlinuz.cent.pxe vnc vncpassword=pass123 headless ip=92.222.83.242 netmask=255.255.255.255 gateway=92.222.64.1 dns=213.186.33.99 ksdevice=eth0 method=http://ftp.hosteurope.de/mirror/centos.org/7/os/x86_64/ lang=en_US keymap=us
#initrd /boot/initrd.img.cent.pxe
#for options see https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/chap-anaconda-boot-options.html
#.

#cat <<. > /boot/grub2/custom.cfg
#default=0
#timeout=15
#menuentry 'Centos Install (PXE)'  --class centos --class gnu-linux --class gnu --class os {
#root=hd0,1
#linux /boot/vmlinuz.cent.pxe  inst.ks=hd:sda1://root/ssg-rhel7-ospp-ks.cfg inst.headless ip=::::::dhcp    ksdevice=eth0
#initrd /boot/initrd.img.cent.pxe
#}
#.



####################################
default=0
timeout=15
menuentry 'Centos Install (PXE)' {
load_video
set gfxpayload=keep
insmod gzio
insmod part_msdos
insmod xfs
set root='hd0,msdos1'
linux16  /vmlinuz.cent.pxe  inst.ks=hd:sda1:://ssg-rhel7-ospp-ks.cfg inst.headless ip=::::::dhcp    ksdevice=eth0 quiet  audit=1
initrd16  /initrd.img.cent.pxe
}
###########################
#inst.repo=http://ftp.hosteurope.de/mirror/centos.org/7/os/x86_64/ lang=en_US keymap=us
#linux /boot/vmlinuz.cent.pxe inst.vnc inst.sshd inst.waitfornet=15 inst.headless inst.vncpassword=pass123  ip=92.222.83.242::92.222.64.1:255.255.255.255:vps422903.ovh.net:eth0:dhcp  ip=2001:41d0:0401:3100:0000:0000:0000:8ae9::::vps422903.ovh.net:eth0:dhcp   nameserver=213.186.33.99 ksdevice=eth0 inst.repo=http://ftp.hosteurope.de/mirror/centos.org/7/os/x86_64/ lang=en_US keymap=us

 grub2-install --recheck /dev/sda
