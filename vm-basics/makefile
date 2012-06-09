# Folders
SERVER_CONFIG_DIR = ~/hetzner-vm-basics
SERVER_CONFIG_INSTALL_DIR = $(SERVER_CONFIG_DIR)
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
	make install_chef

install_main_packages:
	sudo apt-get update
	sudo apt-get -y upgrade
	sudo apt-get -y dist-upgrade
	sudo apt-get -y install build-essential zlib1g-dev libssl-dev openssl libreadline6 libreadline6-dev libyaml-dev curl libcurl4-openssl-dev libexpat1-dev gettext htop wget screen

install_git:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf git-$(GIT_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION) && make prefix=/usr/local all && sudo make prefix=/usr/local install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION)

install_ruby:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf ruby-$(RUBY_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/ruby-$(RUBY_VERSION) && ./configure && make && sudo make install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/ruby-$(RUBY_VERSION)

install_bundler:
	cd $(SERVER_CONFIG_VENDOR_DIR) && sudo gem install bundler-$(BUNDLER_VERSION).gem -l

install_chef:
	cd $(SERVER_CONFIG_INSTALL_DIR) && bundle install --local

