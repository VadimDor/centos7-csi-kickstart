#!/bin/bash

#sudo yum install -y ftp

#HOST=ftp.drivehq.com  #This is the FTP servers host or IP address.
#USER=9735861@mail.ru            #This is the FTP user that has access to the server.
#PASS=mida123  #This is the password for the FTP user.

# Call 1. Uses the ftp command with the -inv switches.
#-i turns off interactive prompting.
#-n Restrains FTP from attempting the auto-login feature.
#-v enables verbose and progress.
# Call 3. Here you will change to the directory where you want to put or get
#Before downloading a file, we should set the local ftp file download directory by using 'lcd' command:
#lcd .
# Call4.  Here you will tell FTP to put or get the file.
# You may want to delete: mdelete efi.tgz
# End FTP Connection
#ftp -inv $HOST << EOF
#user $USER $PASS
#cd EFI
#binary
#get efi.tgz
#bye
#EOF

sudo chmod -R 777 /boot/efi
#sudo tar xvpfz efi.tgz -C /
#sudo chmod -R 777 /boot/efi

sudo yum -y install grub2-efi grub2-efi-modules shim
#sudo mkdir -p /boot/efi/EFI/centos

####################################
cat <<. > /boot/efi/EFI/centos/grub.cfg
set default="1"

function load_video {
  insmod efi_gop
  insmod efi_uga
  insmod ieee1275_fb
  insmod vbe
  insmod vga
  insmod video_bochs
  insmod video_cirrus
  # insmod all_video
}

if loadfont /boot/efi/EFI/centos/fonts/unicode.pf2 ; then
    set gfxmode=auto
    insmod efi_gop
    insmod efi_uga
    insmod gfxterm
    terminal_output gfxterm
fi

set timeout=600
submenu 'Troubleshooting broken installation -->' {
menuentry 'Rescue a CentOS Linux system' --class centos --class gnu-linux --class gnu --class os {
	insmod gzio
	insmod part_msdos
	insmod xfs
 set root='hd0,msdos1'
 linuxefi  /vmlinuz.cent.pxe  inst.ks=hd:sda1:://ssg-rhel7-ospp-ks.cfg inst.headless ip=::::::dhcp    ksdevice=eth0 rescue quiet  audit=1
 initrdefi  /initrd.img.cent.pxe
 }
}
.

sudo ln -sf /boot/efi/EFI/centos/grub.cfg /etc/grub2-efi.cfg
