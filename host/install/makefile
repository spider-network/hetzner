# Folders
SERVER_CONFIG_DIR = ~/hetzner
SERVER_CONFIG_VENDOR_DIR = $(SERVER_CONFIG_DIR)/host/install/vendor

# Programm versions
GIT_VERSION = 1.7.10.3
RUBY_VERSION = 1.9.3-p194
BUNDLER_VERSION = 1.1.4

install:
	make install_main_packages
	make install_git
	make install_ruby
	make install_bundler
	apt-get update
	apt-get -y upgrade
	apt-get -y dist-upgrade

install_main_packages:
	apt-get update
	apt-get -y upgrade
	apt-get -y install screen build-essential make g++ patch gawk zlib1g zlib1g-dev libssl0.9.8 libssl-dev libxml2-dev cpu-checker uml-utilities ubuntu-vm-builder qemu-kvm libvirt-bin virt-top virt-manager htop bridge-utils apache2 apache2.2-common munin munin-node munin-plugins-extra lsof tcpdump curl libcurl3-dev libexpat1-dev imagemagick openssl libreadline6 libreadline6-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison libreadline5-dev vim sysstat

install_git:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf git-$(GIT_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION) && make && make install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION)

install_ruby:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf ruby-$(RUBY_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/ruby-$(RUBY_VERSION) && ./configure && make && make install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/ruby-$(RUBY_VERSION)

install_bundler:
	cd $(SERVER_CONFIG_VENDOR_DIR) && gem install bundler-$(BUNDLER_VERSION).gem -l

fix_postfix:
	# Bug: https://bugs.launchpad.net/ubuntu/+source/postfix/+bug/42947/comments/27
	cp /usr/share/postfix/main.cf.debian /etc/postfix/main.cf
	newaliases
	/etc/init.d/postfix restart
	/etc/init.d/postfix status
