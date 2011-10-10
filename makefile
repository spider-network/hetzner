create_tarball:
	rm -rf /tmp/hetzner
	mkdir -p /tmp/hetzner
	cp -r host /tmp/hetzner
	cp config.yml.example /tmp/hetzner
	cp README.md /tmp/hetzner
	cd /tmp/ && tar cfvz hetzner.tar.gz hetzner && cd - && cp /tmp/hetzner.tar.gz tarball/
