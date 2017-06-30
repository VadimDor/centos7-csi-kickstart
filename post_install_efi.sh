#!/bin/bash

sudo mkdir -p /boot/efi/EFI/centos

sudo ln -sf /boot/efi/EFI/centos/grub.cfg /etc/grub2-efi.cfg
sudo yum -y install grub2-efi grub2-efi-modules shim
#sudo grub2-install --recheck /dev/sda
sudo grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
