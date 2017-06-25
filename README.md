## Hardened CentOS 7 Kickstart
 Here is some additional information added by the supplemental hardening script
 in addition to the SSG

###ABOUT
=====

The ```master``` branch

Modifies a CentOS 7.3+ (1611) (tested with CentOS-7-x86_64-DVD-1702-01.iso) 
x86_64 DVD with a kickstart that will install a system  that is configured and hardened
to meet government-level regulations.

NOTE: ROOT ACCOUNT IS LOCKED WITH INSTALL USE 'admin' ACCOUNT WITH 'sudo' INSTEAD.

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

## Open Source Day 2016

This is Foreman Demo for Open Source Day 2016 Workshop. Please see details [here](http://opensourceday.pl/osd-2016/warsztaty/hardening-i-bezpieczenstwo) (in Polish).

### Installing Foreman and Puppet Agent on Multiple VMs Using Vagrant and VirtualBox
Automatically install and configure Foreman, the open source infrastructure life-cycle management tool, and multiple Puppet Agent VMs using Vagrant and VirtualBox. Project is part of my blog post, [Installing Foreman and Puppet Agent on Multiple VMs Using Vagrant and VirtualBox](http://wp.me/p1RD28-1nb).

The ```centos7``` branch was created 8/20/2015 to reflect changes to original blog post in the ```master``` branch. Changes were required to fix incapability issues with the latest versions of Puppet and Foreman. For details, see [Puppet Compatibility](http://theforeman.org/manuals/1.9/index.html#3.1.2PuppetCompatibility). Additionally, the version of CentOS on all VMs was updated from 6.6 to 7.1 and the version of Foreman was updated from 1.7 to 1.9.

<p><a href="https://programmaticponderings.wordpress.com/?attachment_id=3459" title="New Foreman Hosts" rel="attachment"><img width="620" height="390" src="https://programmaticponderings.files.wordpress.com/2015/08/new-foreman-hosts.png?w=620" alt="New Foreman Hosts"></a></p>

#### Vagrant Plug-ins
This project requires the Vagrant vagrant-hostmanager plugin to be installed. The Vagrantfile uses the vagrant-hostmanager plugin to automatically ensure all DNS entries are consistent between guests as well as the host, in the `/etc/hosts` file. An example of the modified `/etc/hosts` file is shown below.

```text
## vagrant-hostmanager-start id: c472843a-e854-4e58-8a13-856b3b0766f2
192.168.35.5  theforeman.example.com
192.168.35.10 agent01.example.com
192.168.35.20 agent02.example.com
## vagrant-hostmanager-end
```

You can manually run `vagrant hostmanager` to update `/etc/hosts` at anytime.  

This project also requires the Vagrant vagrant-vbguest plugin is also used to keep the vbguest tools updated.
```sh
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
```

```text
==> theforeman.example.com:   Success!
==> theforeman.example.com:   * Foreman is running at https://theforeman.example.com
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
