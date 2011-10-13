# Folders
SERVER_CONFIG_DIR = ~/hetzner
SERVER_CONFIG_VENDOR_DIR = $(SERVER_CONFIG_DIR)/vm/install/vendor

# Programm versions
GIT_VERSION = 1.7.7
RVM_VERSION = 1.8.5
SPHINX_VERSION = 0.9.9
REDIS_VERSION = 2.2.14
MONGODB_VERSION = 2.0.0

install:
	make install_packages
	make install_git
	make install_sphinx
	make install_redis
	make install_mongodb
	make install_rvm

install_packages:
	sudo apt-get update
	sudo apt-get -y upgrade
	sudo apt-get -y install screen build-essential make g++ patch gawk zlib1g zlib1g-dev libssl-dev libxml2-dev cpu-checker uml-utilities htop bridge-utils apache2 lsof tcpdump curl libcurl3-dev libexpat1-dev imagemagick openssl libreadline6 libreadline6-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison openjdk-6-jre-headless ant openjdk-6-jdk subversion vim sendmail wget monit tcsh scons libpcre++-dev libboost-dev xulrunner-1.9.2-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-date-time-dev mysql-server libmysqlclient-dev php5 php5-mysql tcl8.5 sysstat
	sudo apt-get -y upgrade
	sudo apt-get -y dist-upgrade

install_git:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf git-$(GIT_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION) && ./configure && make && sudo make install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/git-$(GIT_VERSION)

install_sphinx:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf sphinx-$(SPHINX_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/sphinx-$(SPHINX_VERSION) && ./configure && make && sudo make install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/sphinx-$(SPHINX_VERSION)

install_redis:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf redis-$(REDIS_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/redis-$(REDIS_VERSION) && make && sudo make install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/redis-$(REDIS_VERSION)

install_mongodb:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf mongodb-linux-x86_64-$(MONGODB_VERSION).tgz
	sudo cp $(SERVER_CONFIG_VENDOR_DIR)/mongodb-linux-x86_64-$(MONGODB_VERSION)/bin/* /usr/local/bin/
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/mongodb-linux-x86_64-$(MONGODB_VERSION)
	sudo mkdir -p /data/db/

install_rvm:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf rvm-$(RVM_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/rvm-$(RVM_VERSION) && ./install
	/usr/local/rvm/bin/rvm install 1.9.2-p290
	/usr/local/rvm/bin/rvm 1.9.2-p290 --default
	/usr/local/rvm/bin/rvm gem install bundler --no-rdoc --no-ri
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/rvm-$(RVM_VERSION)
	. /etc/profile.d/rvm.sh
	gem install passenger
