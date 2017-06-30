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


#kernel /boot/vmlinuz.cent.pxe vnc vncpassword=pass123 headless ip=92.222.83.242 netmask=255.255.255.255 gateway=92.222.64.1 dns=213.186.33.99 ksdevice=eth0 method=http://ftp.hosteurope.de/mirror/centos.org/7/os/x86_64/ lang=en_US keymap=us

#for options see https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/chap-anaconda-boot-options.html

####################################
cat <<. > /boot/grub2/custom.cfg
 default=0
 timeout=15
 menuentry 'Centos Install (PXE)'  --class centos --class gnu-linux --class gnu --class os {
load_video
set gfxpayload=keep
insmod gzio
insmod part_msdos
insmod xfs
set root='@@boot_disk@@'
  linux16 /vmlinuz.cent.pxe  inst.ks=hd:@@sda@@://hardened-centos.cfg inst.headless ip=::::::dhcp    ksdevice=@@eth0@@ @@inst.vnc@@
  initrd16 /initrd.img.cent.pxe
 }
.
#inst.repo=http://ftp.hosteurope.de/mirror/centos.org/7/os/x86_64/ lang=en_US keymap=us
#linux /boot/vmlinuz.cent.pxe inst.vnc inst.sshd inst.waitfornet=15 inst.headless inst.vncpassword=pass123  ip=92.222.83.242::92.222.64.1:255.255.255.255:vps422903.ovh.net:eth0:dhcp  ip=2001:41d0:0401:3100:0000:0000:0000:8ae9::::vps422903.ovh.net:eth0:dhcp   nameserver=213.186.33.99 ksdevice=eth0 inst.repo=http://ftp.hosteurope.de/mirror/centos.org/7/os/x86_64/ lang=en_US keymap=us

 grub2-install --recheck /dev/sda
