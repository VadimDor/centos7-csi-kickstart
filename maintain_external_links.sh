git submodule init
git submodule update
git submodule add  https://github.com/VadimDor/hardened-centos7-kickstart
ln -s  hardened-centos7-kickstart/config/hardening/supplemental.sh 
git add .gitmodules supplemental.sh
ln -s  hardened-centos7-kickstart/config/hardening/hardened-centos.cfg
git add .gitmodules hardened-centos.cfg
ln -s  hardened-centos7-kickstart/config/hardening/iptables.sh
ln -s  hardened-centos7-kickstart/config/hardening/iptables.sh
git add .gitmodules iptables.sh
git commit -m "added a symbolic links to lexternal repos with the respective submodule"

history | cut -c 8-|tail -n 50 > ../mountaine_external_repo.sh
