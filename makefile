create_tarballs:
	make host_tarball
	make vm_tarball

host_tarball:
	rm -rf /tmp/host/hetzner
	mkdir -p /tmp/host/hetzner
	cp -r host /tmp/host/hetzner
	cp README.md /tmp/host/hetzner
	cd /tmp/host/ && tar cfvz hetzner-host.tar.gz hetzner && cd - && cp /tmp/host/hetzner-host.tar.gz tarball/
	scp tarball/hetzner-host.tar.gz ssh-46282-df@voigt-mail.de:websites/spider-network/downloads/

vm_tarball:
	rm -rf /tmp/vm/hetzner
	mkdir -p /tmp/vm/hetzner
	cp -r vm /tmp/vm/hetzner
	cp README.md /tmp/vm/hetzner
	cd /tmp/vm/ && tar cfvz hetzner-vm.tar.gz hetzner && cd - && cp /tmp/vm/hetzner-vm.tar.gz tarball/
	scp tarball/hetzner-vm.tar.gz ssh-46282-df@voigt-mail.de:websites/spider-network/downloads/
