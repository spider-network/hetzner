install:
	make create_host_tarball
	make create_vm_basics_tarball
	make sync_tarballs

create_host_tarball:
	rm -rf /tmp/host/hetzner
	mkdir -p /tmp/host/hetzner
	cp -r host /tmp/host/hetzner
	cp README.md /tmp/host/hetzner
	cd /tmp/host/ && tar cfvz hetzner-host.tar.gz hetzner && cd - && cp /tmp/host/hetzner-host.tar.gz tarball/

create_vm_basics_tarball:
	rm -rf /tmp/vm/hetzner-vm-basics
	mkdir -p /tmp/vm/hetzner-vm-basics
	cp -r vm-basics/ /tmp/vm/hetzner-vm-basics
	cp README.md /tmp/vm/hetzner-vm-basics
	cd /tmp/vm && tar cfvz hetzner-vm-basics.tar.gz hetzner-vm-basics && cd - && cp /tmp/vm/hetzner-vm-basics.tar.gz tarball/

sync_tarballs:
	scp tarball/hetzner-host.tar.gz ssh-46282-df@voigt-mail.de:websites/spider-network/downloads/
	scp tarball/hetzner-vm-basics.tar.gz ssh-46282-df@voigt-mail.de:websites/spider-network/downloads/
