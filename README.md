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

#### Install steps:
1. Login via SSH

    ``ssh root@177.10.0.8 -A``

1. I recommend to run the installation in a [screen session](http://de.wikipedia.org/wiki/GNU_Screen), because it
will take at least 15 minutes.

    ``apt-get update && apt-get -y install screen``

    - ``screen``: Start a new screen session. Detach the session with ``ctrl+a d``
    - ``screen -r``: Reattach to a detached screen process.


1. Download and extract the setup script (The path must be "/root/hetzner")

    ``wget http://www.spider-network.net/downloads/hetzner-host.tar.gz && tar xvf hetzner-host.tar.gz``

1. Start the installation

    ``cd /root/hetzner/host/install && make install``

    After the installation, you have to logout and login again.

1. Install missing Gem-Packages

    ``cd /root/hetzner/host/install && bundle install``

1. Edit used yaml configuration

    ``cp /root/hetzner/host/install/config.yml.example /root/hetzner/host/install/config.yml``

    ``vi /root/hetzner/config.yml``

    Example:
    <pre>
    server:
      host:
        ip: 177.10.0.8
        hostname: server-001.domain.tpl
        subnet:
          ip: 79.48.232.8
          maske: 255.255.255.248
          broadcast: 79.48.232.15
          net: 177.10.0.0
          gateway: 79.48.232.14
          dns: '213.133.98.98 213.133.99.99 213.133.100.100'
          ips:
            - 79.48.232.9
            - 79.48.232.10
            - 79.48.232.11
            - 79.48.232.12
            - 79.48.232.13
        ssh_authorized_keys:
          - ssh-dss AAAAB3NzaC1kc3MAAAEB.../MEwJ7i2F8kYXpcz== michael@voigt
        tools:
          munin:
            htpasswd: Munin:1$vftlsa29t6M
    </pre>

1. Server configuration (``cd /root/hetzner/host/install``)

    - ``thor hetzner:host:install:configure_authorized_keys``
    - ``thor hetzner:host:install:configure_hostname``
    - ``thor hetzner:host:install:configure_network``
    - ``thor hetzner:host:install:configure_munin``

#### Create and manage VM's:

- Create a new VM (It can take up to 20 minutes. I recommend to do this inside a [screen session](http://de.wikipedia.org/wiki/GNU_Screen) (see above).)

    ``thor hetzner:host:vm:create --ip=79.48.232.9 --name=vm-001 --user-pass=password``

    - Options:
    <pre>
    :name      => :required, # Name of the VM. e.g. vm-001
    :user_name => 'server',  # Linux user (Default: server)
    :user_pass => :required, # Password for the Linux user
    :ip        => :required, # VM IP, one of the available IP's from your subnet. e.g. 79.48.232.9
    :cpus      => 4,         # VM CPU cores (Default: 4)
    :ram       => 4096,      # VM RAM (Default: 4096 MB)
    :swap      => 1024,      # VM Swap (Default: 1024 MB)
    :hdd       => 20480      # VM HDD (Default: 20480 MB)
    </pre>

    - Increase IO performance (add: ``cache='writeback'``):

        ``thor hetzner:host:vm:edit --name=vm-001``

        ```xml
        <disk type='file' device='disk'>
          <driver name='qemu' type='qcow2' cache='writeback'/>
          <source file='/root/vms/vm-002/tmphJhs3T.qcow2'/>
          <target dev='hda' bus='ide'/>
        </disk>
        ```
        Don't forget to restart the VM.

- Show all VM's and the status (running, shut off)

    ``thor hetzner:host:vm:list``

- Stop the given VM

    ``thor hetzner:host:vm:stop --name=vm-001``

- Start the given VM

    ``thor hetzner:host:vm:start --name=vm-001``

- Create a backup (dump)

    ``thor hetzner:host:vm:backup --name=vm-001``

- Show all backups from the given VM

    ``thor hetzner:host:vm:backups --name=vm-001``

- Restore the VM from backup dump

    ``thor hetzner:host:vm:stop --name=vm-001``

    ``thor hetzner:host:vm:restore --file=vm_backup_20111012-1247 --name=vm-001``

#### Install VM environment

1. Login via SSH

    ``ssh server@79.48.232.9 -A``

1. Download and extract the setup script (The path must be "~/hetzner")

    ``wget http://www.spider-network.net/downloads/hetzner-vm.tar.gz && tar xvf hetzner-vm.tar.gz``

1. Start the installation (I recommend to do this inside a [screen session](http://de.wikipedia.org/wiki/GNU_Screen) (see above).)

    ``cd ~/hetzner/vm/install && make install``

    After the installation, you have to logout and login again.

1. Install missing Gem-Packages

    ``cd ~/hetzner/vm/install && bundle install``

1. Install Phusion Passenger

    ``passenger-install-apache2-module``

1. Define rails environment

    ``echo 'export RAILS_ENV=production' >> ~/.bashrc``

1. Adapt Apache configuration

    ``cd ~/hetzner/vm/install && make configure_apache``

Then you can deploy your Rails application to ``~/rails-application/current/``.

Contributing and Support
------------------------
If you have any suggestions or criticism write me an e-mail [michael.voigt@spider-network.net](mailto:michael.voigt@spider-network.net)
or create an issue. If you need help just contact me. I will always support the latest Ubuntu LTS ("Long Term Support")
version, which is currently "Ubuntu 10.04 LTS".
