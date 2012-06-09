# Folders
SERVER_CONFIG_DIR = ~/hetzner
SERVER_CONFIG_INSTALL_DIR = $(SERVER_CONFIG_DIR)/host/install
SERVER_CONFIG_VENDOR_DIR = $(SERVER_CONFIG_INSTALL_DIR)/vendor

# Programm versions
GIT_VERSION = 1.7.10.3
RUBY_VERSION = 1.9.3-p194
BUNDLER_VERSION = 1.1.4

install:
	make install_main_packages
	make install_git
	make install_ruby
	make install_bundler
	make install_gems

install_main_packages:
	apt-get update
	apt-get -y upgrade
	apt-get -y dist-upgrade
	apt-get -y install screen build-essential make g++ patch gawk zlib1g zlib1g-dev libssl0.9.8 libssl-dev libxml2-dev cpu-checker uml-utilities ubuntu-vm-builder qemu-kvm libvirt-bin virt-top virt-manager htop bridge-utils apache2 apache2.2-common lsof tcpdump curl libcurl4-openssl-dev libexpat1-dev imagemagick openssl libreadline6 libreadline6-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxslt1-dev autoconf libc6-dev libncurses5-dev automake libtool bison vim sysstat

install_git:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf git-$(GIT_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION) && make prefix=/usr/local all && make prefix=/usr/local install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION)

install_ruby:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf ruby-$(RUBY_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/ruby-$(RUBY_VERSION) && ./configure && make && make install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/ruby-$(RUBY_VERSION)

install_bundler:
	cd $(SERVER_CONFIG_VENDOR_DIR) && gem install bundler-$(BUNDLER_VERSION).gem -l

install_gems:
	cd $(SERVER_CONFIG_INSTALL_DIR) && bundle install --local
