# Folders
SERVER_CONFIG_DIR = ~/hetzner
SERVER_CONFIG_VENDOR_DIR = $(SERVER_CONFIG_DIR)/host/install/vendor

# Programm versions
GIT_VERSION = 1.7.7
RVM_VERSION = 0.0.84

install:
	make install_packages
	make fix_postfix
	make install_git
	make install_rvm
	apt-get update
	apt-get -y upgrade
	apt-get -y dist-upgrade

install_packages:
	apt-get update
	apt-get -y upgrade
	apt-get -y install screen build-essential make g++ patch gawk zlib1g zlib1g-dev libssl-dev libxml2-dev cpu-checker uml-utilities ubuntu-vm-builder qemu-kvm libvirt-bin virt-top virt-manager htop bridge-utils apache2 munin munin-node munin-plugins-extra lsof tcpdump curl libcurl3-dev libexpat1-dev imagemagick openssl libreadline6 libreadline6-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison

install_git:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf git-$(GIT_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION) && ./configure && make && make install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION)

install_rvm:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf rvm-$(RVM_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/rvm-$(RVM_VERSION) && ./install
	cp $(SERVER_CONFIG_VENDOR_DIR)/ruby-1.9.2-p290.tar.gz /usr/local/rvm/archives/
	cp $(SERVER_CONFIG_VENDOR_DIR)/rubygems-1.8.10.tgz /usr/local/rvm/archives/
	cp $(SERVER_CONFIG_VENDOR_DIR)/yaml-0.1.4.tar.gz /usr/local/rvm/archives/
	rvm install 1.9.2-p290
	rvm 1.9.2-p290 --default
	gem install bundler --no-rdoc --no-ri

fix_postfix:
	# Bug: https://bugs.launchpad.net/ubuntu/+source/postfix/+bug/42947/comments/27
	cp /usr/share/postfix/main.cf.debian /etc/postfix/main.cf
	newaliases
	/etc/init.d/postfix restart
	/etc/init.d/postfix status
