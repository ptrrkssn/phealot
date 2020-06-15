# Makefile for phealot

DESTDIR =

prefix =	/usr
libexecdir =	${prefix}/libexec

INSTALL =	/usr/bin/install -c


all:
	@echo "Valid targets: 'install', 'install-deps', 'clean', 'pull' or 'push'"
	@exit 1

clean:
	-rm -f *~ \#*

install: phealot
	$(INSTALL) phealot "$(DESTDIR){libexecdir}"

install-deps:
	@$(MAKE) install-deps-`uname -s`

install-deps-FreeBSD:
	pkg install p5-Net-DNS

install-deps-Linux:
	@if test -f /etc/centos-release; then \
	  $(MAKE) install-deps-CentOS; \
	else \
	  $(MAKE) install-deps-Ubuntu; \
	fi

install-deps-Ubuntu:
	apt-get install libnet-dns-perl

install-deps-CentOS:
	yum install perl-Net-DNS

# If all else fails, try CPAN
install-deps-CPAN:
	perl -MCPAN -e 'install Net::DNS'


pull:
	git pull

push:	clean
	git add -A && git commit -a && git push
