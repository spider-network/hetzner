# Folders
SERVER_CONFIG_DIR = ~/hetzner
SERVER_CONFIG_VENDOR_DIR = $(SERVER_CONFIG_DIR)/vm/install/vendor
SERVER_CONFIG_TEMPLATE_DIR = $(SERVER_CONFIG_DIR)/vm/install/templates

# Programm versions
GIT_VERSION = 1.7.9.3
RVM_VERSION = 1.10.3
SPHINX_VERSION = 0.9.9
REDIS_VERSION = 2.4.8
MEMCACHED_VERSION = 1.4.13
ELASTICSEARCH_VERSION = 0.19.0

install:
	make install_packages
	make install_git
	make install_sphinx
	make install_redis
	make install_mongodb
	make install_memcached
	make install_rvm
	make install_dotfiles
	make install_elasticsearch

install_packages:
	sudo apt-get update
	sudo apt-get -y upgrade
	sudo apt-get -y install screen build-essential make g++ patch gawk zlib1g zlib1g-dev libssl-dev libxml2-dev cpu-checker uml-utilities htop bridge-utils apache2 apache2-prefork-dev libapr1-dev libaprutil1-dev lsof tcpdump curl libcurl3-dev libexpat1-dev imagemagick openssl libreadline6 libreadline6-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison openjdk-6-jre-headless ant openjdk-6-jdk subversion vim sendmail wget monit tcsh scons libpcre++-dev libboost-dev xulrunner-1.9.2-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-date-time-dev mysql-server libmysqlclient-dev php5 php5-mysql tcl8.5 sysstat libevent-dev
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
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
	sudo cp $(SERVER_CONFIG_TEMPLATE_DIR)/etc/apt/sources.list /etc/apt/sources.list
	sudo apt-get update
	sudo apt-get install mongodb-10gen

install_memcached:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf memcached-$(MEMCACHED_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/memcached-$(MEMCACHED_VERSION) && ./configure && make && sudo make install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/memcached-$(MEMCACHED_VERSION)

install_rvm:
	cd $(SERVER_CONFIG_VENDOR_DIR) && tar -xvf rvm-$(RVM_VERSION).tar.gz
	cd $(SERVER_CONFIG_VENDOR_DIR)/rvm-$(RVM_VERSION) && ./install
	rm -rf $(SERVER_CONFIG_VENDOR_DIR)/rvm-$(RVM_VERSION)
	~/.rvm/bin/rvm install 1.9.2-p290
	~/.rvm/bin/rvm install 1.9.3-p125
	~/.rvm/bin/rvm install ree
	~/.rvm/bin/rvm use 1.9.2-p290 --default
	~/.rvm/bin/rvm gem install bundler --no-rdoc --no-ri

configure_apache:
	sudo cp $(SERVER_CONFIG_TEMPLATE_DIR)/etc/apache2/sites-available/rails-application /etc/apache2/sites-available/rails-application
	sudo rm /etc/apache2/sites-enabled/000-default
	cd /etc/apache2/sites-enabled/ && sudo ln -s /etc/apache2/sites-available/rails-application rails-application
	sudo a2enmod headers
	sudo /etc/init.d/apache2 stop && sudo /etc/init.d/apache2 start
	mkdir -p ~/rails-application

configure_monit:
	sudo cp $(SERVER_CONFIG_TEMPLATE_DIR)/etc/mysql/conf.d/pid.cnf /etc/mysql/conf.d/pid.cnf
	sudo /etc/init.d/mysql stop && sudo /etc/init.d/mysql start
	sudo cp $(SERVER_CONFIG_TEMPLATE_DIR)/etc/monit/monitrc /etc/monit/monitrc
	sudo cp $(SERVER_CONFIG_TEMPLATE_DIR)/etc/monit/conf.d/* /etc/monit/conf.d/
	sudo cp $(SERVER_CONFIG_TEMPLATE_DIR)/etc/default/monit /etc/default/monit
	sudo /etc/init.d/monit stop && sleep 5 && sudo /etc/init.d/monit start
	sleep 5 && sudo monit monitor all
	sleep 5 && sudo monit status

install_dotfiles:
	cp $(SERVER_CONFIG_TEMPLATE_DIR)/dotfiles/profile ~/.profile
	cp $(SERVER_CONFIG_TEMPLATE_DIR)/dotfiles/profile ~/.bash_profile
	rm ~/.bash_login

install_elasticsearch:
	sudo dpkg -i $(SERVER_CONFIG_VENDOR_DIR)/elasticsearch-0.19.0.deb
