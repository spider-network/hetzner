Hosting setup for a Hetzner Root-Server (virtualization with KVM)
=================================================================

[Hetzner Online AG](http://www.hetzner.de) is in my opinion a very good web hosting provider.
I do not work for Hetzner. I accept no responsibility for possible errors in the script and
instructions (The risk is yours!). The reason for using server virtualization was to have multiple
independent systems for development, test, staging and production.

What do you need from Hetzner?

- Root Server _(49€ per month for an [EX4](http://www.hetzner.de/hosting/produktmatrix/rootserver-produktmatrix-ex) with 16GB RAM & 2x3TB HDD or 59€ per month for an [EX5](http://www.hetzner.de/hosting/produktmatrix/rootserver-produktmatrix-ex) with 24GB RAM & 2x750GB HDD)_
- Flexi Pack is necessary to order IP subnet. _(15€ per month)_
- Subnet /29 _(5.40€ per month)_

The price of the setup is awesome and you get on top 100GB backup space (SFTP). (Prices from October 2011)

Installation and configuration
------------------------------

Hetzner example configuration:

    Ubuntu 10.04.3 LTS
    Main Server IP: 177.10.0.8

    Subnet: 79.48.232.8 /29
    Maske: 255.255.255.248
    Broadcast: 79.48.232.15

    Available IP addresses:
    79.48.232.9 bis 79.48.232.14 

One of the available IP addresses "79.48.232.14" will be used for the Gateway configuration.

#### Install steps:
1. Login via SSH

    ssh root@177.10.0.8 -A

1. Download and extract the setup script (The path must be "/root/hetzner")

    wget http://www.spider-network.net/downloads/hetzner.tar.gz && tar xvf hetzner.tar.gz

1. Start the installation

    cd /root/hetzner/host/install && make install

    After the installation, you have to logout and login again.

1. Install missing Gem-Packages

    cd /root/hetzner/host/install && bundle install

1. Edit used yaml configuration

    cp /root/hetzner/config.yml.example /root/hetzner/config.yml
    vi /root/hetzner/config.yml
    
        server:
          host:
            ip: 177.10.0.8
            hostname: server-001.domain.tpl
            subnet:
              ip: 79.48.232.8
              maske: 255.255.255.248
              broadcast: 79.48.232.15
              gateway: 79.48.232.14
              ips:
                - 79.48.232.9
                - 79.48.232.10
                - 79.48.232.11
                - 79.48.232.12
                - 79.48.232.13
            ssh_authorized_keys:
              - ssh-dss AAAAB3NzaC1kc3MAAAEBAL...i2F8kYXpcz== michael@voigt
            tools:
                munin:
                  htpasswd: Munin:1$vftlsa29t6M


1. Server configuration

    - thor hetzner:host:install:configure_authorized_keys
    - thor hetzner:host:install:configure_hostname
    - thor hetzner:host:install:configure_network
    - thor hetzner:host:install:configure_munin


Contributing and Support
------------------------
If you have any suggestions or criticism write me an e-mail [michael.voigt@spider-network.net](mailto:michael.voigt@spider-network.net)
or create an issue. If you need help just contact me. I will always support the latest Ubuntu LTS ("Long Term Support")
version, which is currently "Ubuntu 10.04 LTS".
