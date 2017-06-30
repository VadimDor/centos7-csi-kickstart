#!/bin/sh
# Check for root user
if [[ $EUID -ne 0 ]]; then
tput setaf 1;echo -e "\033[1mPlease re-run this script as root!\033[0m";tput sgr0
exit 1
fi

echo Installing python, bc packages
sudo yum install -y python, bc


tput setaf 1;\
echo \
$' ################################\n' \
$'# Running Pre Configuration    #\n' \
$'################################\033[0m'\
;tput sgr0

# create a variable to hold the input
read -p "Give hostname (if default '$(hostname)' is OK press ENTER): " host_name
# Check if string is empty using -z. For more 'help test'
if [[ -z "$host_name" ]]; then
   host_name=$(hostname)
fi
sed -i -e 's/@@host_name@@/$host_name/g' /boot/hardened-centos.sh
printf "Hostname selected to be %s \n" $host_name
############################################################
# boot network interface
eth=`/sbin/ifconfig -a  | awk '/BROADCAST/{ print $1;} '|head -n1|sed 's/://'`
eth_known=`/sbin/ifconfig -a  | awk '/RUNNING/{ print $1;} ' | paste -d, -s`
read -p "Give network interface  (known are '$eth_known',if default '$eth' is OK press ENTER): " eth_name
if [[ -z "$eth_name" ]]; then
   eth_name=$eth
fi
sed -i -e 's/@@eth0@@/$eth_name/g' /boot/prepare-grub.sh
sed -i -e 's/@@eth@@/$eth_name/g' /boot/hardened-centos.sh
printf "Network interface selected to be %s \n" $eth_name


ipv6=`ip addr show dev eth0 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d'`
##################################
ipv6_def=`ip addr show dev eth0 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d'`
echo "Found current ipv6 address $ipv6_def
read -p "Enter the required ipv6 address for system to be installed (press ENTER to retain $ipv6_def): " ipv6
if [[ -z "$ipv6" ]]; then
  ipv6=$ipv6_def
fi
sed -i -e 's/@@ipv6@@/$ipv6/g' /boot/hardened-centos.sh
printf "ipv6 address selected to be %s \n" $ipv6
##################################
# Read secret string
read_secret()
{
  local   root_pass=""
  local   root_pass_rep=""
  stty -echo
  trap 'stty echo' EXIT

  while [[ $root_pass != $root_pass_rep ]] || [[ $root_pass == '' ]] # While string is different or empty...
   do
    printf "Give NOT EMPTY password for $1: "
    read    root_pass
    printf "please repeat: "
    read   root_pass_rep
    if [[ $root_pass != $root_pass_rep ]]; then
       echo "Passwords not equal. Please try again"
     else
        if [[ $root_pass == '' ]]; then
           echo 'Empty string entered'
         else
          echo "OK"
          break
     fi
    fi
    echo "Enter a valid string" # Ask the user to enter a valid string
  done

printf "\n"
stty echo
trap - EXIT
echo
root_pass=`echo 'import crypt,getpass; print crypt.crypt("$root_pass", "$6$16_CHARACTER_SALT_HERE")' | python -`
echo "$root_pass"
}

stty echo
read_secret "system's root" system_root   # or result=`read_secret`
sed -i -e 's/@@system_root@@/$system_root/g' /boot/hardened-centos.sh

read_secret "user 'admin'" user_admin
sed -i -e 's/@@user_admin@@/$user_admin/g' /boot/hardened-centos.sh

read_secret "user 'bootuser' for selecting restricted menuitems from bootmenu" bootuser
sed -i -e 's/@@bootuser@@/$bootuser/g' /boot/hardened-centos.sh
bootuser_grub=`echo -e 'mypass\nmypass' | grub2-mkpasswd-pbkdf2 | awk '/grub.pbkdf/{print$NF}'`
sed -i -e 's/@@bootuser_grub@@/$bootuser_grub/g' /boot/hardened-centos.sh




###########################################
echo "Known boot entries in GRUB-configuration currently show as boot disks the following:"
cat /boot/grub2/grub.cfg|grep "set root="|cut -d '=' -f2
boot_disk_def=`cat /boot/grub2/grub.cfg|grep "set root="|cut -d '=' -f2|head -n1`
read -p "Enter (NOT quoted) the boot disk (press ENTER for default $boot_disk_def): " boot_disk
if [[ -z "$boot_disk" ]]; then
  boot_disk=$boot_disk_def
fi
sed -i -e 's/@@boot_disk@@/$boot_disk/g' /boot/prepare-grub.sh
printf "Boot disk selected to be %s \n" $boot_disk
###########################################
echo Found the following storage devices:
sudo fdisk -l | grep 'Boot'
sudo fdisk -l | grep -A100 'Boot'| grep "^/dev"
sda_def=`fdisk -l | grep -A1000 'Boot'| grep "^/dev"|grep "*"|cut -d ' ' -f1 | cut -d/ -f3-`
read -p "Enter (NOT quoted) the sorage device to boot the installation from (press ENTER for default $sda_def): " sda
if [[ -z "$sda" ]]; then
  sda=$sda_def
fi
sed -i -e 's/@@sda@@/$sda/g' /boot/prepare-grub.sh
printf "Boot device selected to be %s \n" $sda
###########################################
#to check current space consumtiong:  du -cksh ../* 2>>/dev/null
size=`sudo fdisk -l | awk '/Disk \/dev\/sda/{ print $3;}'`
size_mb=$(printf %.0f $(echo "($size*1024)*1.00" | bc -l))
echo "Total size of the first hd (assumed to be /dev/sda) is $size GB ($size_mb MB)"
#part=$(echo  '3 $size * p' | dc)
#part=$(bc<<<"$size*0.30")
#part=$((part * 1000))
echo Partition sizes will be calculated by default. If not agree, please edit precentage in this file. So:
root_partition=$(printf %.0f $(echo "($size*1024)*0.35" | bc -l))
echo "root(/) partition will be $root_partition MB (35%)"
sed -i -e 's/@@root_partition@@/$root_partition/g' /boot/hardened-centos.sh

home_partition=$(printf %.0f $(echo "($size*1024)*0.10" | bc -l))
echo "home partition will be $home_partition MB (10%)"
sed -i -e 's/@@home_partition@@/$home_partition/g' /boot/hardened-centos.sh

tmp_partition=$(printf %.0f $(echo "($size*1024)*0.10" | bc -l))
echo "tmp partition will be $tmp_partition MB (10%)"
sed -i -e 's/@@tmp_partition@@/$tmp_partition/g' /boot/hardened-centos.sh

var_partition=$(printf %.0f $(echo "($size*1024)*0.10" | bc -l))
echo "var partition will be $var_partition MB (10%)"
sed -i -e 's/@@var_partition@@/$var_partition/g' /boot/hardened-centos.sh

log_partition=$(printf %.0f $(echo "($size*1024)*0.05" | bc -l))
echo "log partition will be $log_partition MB (5%)"
sed -i -e 's/@@log_partition@@/$log_partition/g' /boot/hardened-centos.sh

audit_partition=$(printf %.0f $(echo "($size*1024)*0.05" | bc -l))
echo "audit partition will be $audit_partition MB (5%)"
sed -i -e 's/@@audit_partition@@/$audit_partition/g' /boot/hardened-centos.sh

swap_partition=$(printf %.0f $(echo "($size*1024)*0.15" | bc -l))
echo "swap partition will be $swap_partition MB (15%)"
sed -i -e 's/@@swap_partition@@/$swap_partition/g' /boot/hardened-centos.sh

boot_partition=$(printf %.0f $(echo "($size*1024)*0.02" | bc -l))
echo "boot partition will be $boot_partition MB (2%)"
sed -i -e 's/@@boot_partition@@/$boot_partition/g' /boot/hardened-centos.sh

efi_partition=$(printf %.0f $(echo "($size*1024)*0.01" | bc -l))
echo "efi partition will be $efi_partition MB (1%)"
sed -i -e 's/@@efi_partition@@/$efi_partition/g' /boot/hardened-centos.sh

www_partition=$(printf %.0f $(echo "($size*1024)*(0.1-0.02-0.01)" | bc -l))
echo "www partition will be $www_partition MB (9%)"
sed -i -e 's/@@www_partition@@/$www_partition/g' /boot/hardened-centos.sh

summ_mb=$(printf %.0f $( echo \
 "$root_partition+$home_partition+$tmp_partition+ \
 $var_partition+$log_partition+$audit_partition+$swap_partition+ \
 $www_partition+$efi_partition+$boot_partition" | bc -l))
not_mounted=$(printf %.0f $(echo "$size_mb-$summ_mb" | bc -l))
echo "all in all: $summ_mb MB (not mounted $not_mounted MB)"
###########################################
echo '213.85.1.125:5500'
echo "If your VDS provider offers KVM access to your server, you will be able control your installation over KVM .\n"
echo "If not you will be able control your installation over VNC starinv vncviewer on your workstation "
echo "and setting it to wait for this server asks for connection during install."
echo "We recomend to use free TigerVNC (tigervnc.org) on default port 5500."
echo "If you are behind a firewall or home router, don't forget to forward this port."
echo "Your IP address you can find with http://WhatisMyIp.org\n"
read -p "Please provide the VNC viewer's IP or name and port it will be listen on, e.g. 215.1.2.3:5500 (press ENTER if you prefer KVM or have a console): " vnc_string
if [[ -z "$vnc_string" ]]; then
   printf '%s \n' "VNC control support disabled"
   sed -i -e 's/@@inst.vnc@@/inst.vnc inst.vncconnect=$vnc_string/g' /boot/prepare-grub.sh
else
  printf "VNC control support enabled for listening vncviewer %s \n" "'$vnc_string'"
  sed -i -e 's/@@inst.vnc@@/ /g' /boot/prepare-grub.sh
fi
###########################################
locale_def=`localectl status|grep LANG=|cut -d'=' -f2-`
keyboard_def=`localectl status|grep 'VC Keymap'|cut -d':' -f2-`
echo "Found current system locale $locale_def and keyboard layout $keyboard_def"
read -p "Enter the required locale for system to be installed (press ENTER to retain $locale_def): " locale
if [[ -z "$locale" ]]; then
  locale=$locale_def
fi
sed -i -e 's/@@locale@@/$locale/g' /boot/hardened-centos.sh
printf "System locale selected to be %s \n" $locale
##############
read -p "Enter the required keyboard layout for system to be installed(press ENTER to retain $locale_def): " keyboard
if [[ -z "$keyboard" ]]; then
  keyboard=$keyboard_def
fi
sed -i -e 's/@@keyboard@@/$keyboard/g' /boot/hardened-centos.sh
printf "Keyboard layout selected to be %s \n" $keyboard
##############
locale_name=LANG=`locale -a|grep $keyboard_def|head -n1` locale -ck LC_IDENTIFICATION|grep language=|tr -d '"'|cut -d '=' -f2 |  tr '[:upper:]' '[:lower:]'
read -p "Do you want add `$keyboard_def|tr '[:lower:]' '[:upper:]'` support for system to be installed(y|n)?: " yYnN
input=`echo $yNN|tr '[:upper:]' '[:lower:]'`
if [[ -z "$input" ]] ||  [[$input == 'y']]; then
  sed -i -e 's/@@locale_name@@/$locale_name/g' /boot/hardened-centos.sh
  printf "Extra support will be added for locale  %s \n" $locale_name
else
  sed -i -e 's/@@@locale_name@@-support/##no extra locale support needed/g' /boot/hardened-centos.sh
  printf "No extra support for locale will be added\n"
fi
##########################################
unset yYnN
read -p "Do you want instal Foreman(y|n)?: " yYnN
input=`echo $yNN|tr '[:upper:]' '[:lower:]'`
if [[ -z "$input" ]] ||  [[$input == 'y']]; then
  printf "Foreman will be installed\n"
else
    printf "Foreman will be not installed\n"
fi
#########################################
