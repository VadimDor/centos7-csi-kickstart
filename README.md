## Hardened CentOS 7 Kickstart
 Here is some additional information added by the supplemental hardening script
 in addition to the SSG

 To start run on the server:
**1.**
 wget https://raw.githubusercontent.com/VadimDor/centos7-csi-kickstart/master/bootstrap-server.sh
  OR  shorten form
 wget https://goo.gl/EuGLff -O bootstrap-server.sh
** 2.**
 sudo chmod +x bootstrap-server.sh
**3**
sudo ./bootstrap-server.sh 

### ABOUT

The ```master``` branch

Modifies a CentOS 7.3+ (1611) (tested with CentOS-7-x86_64-DVD-1702-01.iso)
x86_64 DVD with a kickstart that will install a system  that is configured and hardened
to meet government-level regulations.

# NOTE: ROOT ACCOUNT IS LOCKED WITH INSTALL USE 'admin' ACCOUNT WITH 'sudo' INSTEAD.

The kickstart script involves the integration of the following projects
into a single installer:

   - classification-banner.py (Python for displaying a graphical classification banner)

        https://github.com/RedHatGov/classification-banner

   - SCAP Security Guide (SSG) - Hardening Script for CentOS7

        https://github.com/openscap/scap-security-guide

#### CONTENT
```text
## vagrant-hostmanager-start id: c472843a-e854-4e58-8a13-856b3b0766f2
192.168.35.5  theforeman.example.com
192.168.35.10 agent01.example.com
192.168.35.20 agent02.example.com
## vagrant-hostmanager-end
```

```sh
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
```

```sh
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
```



#### Errors
**Error: Unknown configuration section 'hostmanager'.**
=> **Solution: **Install the `vagrant-hostmanager` plugin with `vagrant plugin install vagrant-hostmanager`

#### Useful Multi-VM Commands
The use of the specific <machine> name is optional in most cases.
* `vagrant up <machine>`
* `vagrant reload <machine>`


#### Errors
**Error: Unknown configuration section 'hostmanager'.**
=> **Solution: **Install the `vagrant-hostmanager` plugin with `vagrant plugin install vagrant-hostmanager`

#### Useful Multi-VM Commands
The use of the specific <machine> name is optional in most cases.
* `vagrant up <machine>`
* `vagrant reload <machine>`
