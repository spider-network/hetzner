install:
	make create_host_tarball
	make sync_tarball

create_host_tarball:
	rm -rf /tmp/host/hetzner
	mkdir -p /tmp/host/hetzner
	cp -r host /tmp/host/hetzner
	cp README.md /tmp/host/hetzner
	cd /tmp/host/ && tar cfvz hetzner-host.tar.gz hetzner && cd - && cp /tmp/host/hetzner-host.tar.gz tarball/

sync_tarball:
	scp tarball/hetzner-host.tar.gz ssh-46282-df@voigt-mail.de:websites/spider-network/downloads/
