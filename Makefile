# Makefile for phealot

DESTDIR =

prefix =	/usr
libexecdir =	${prefix}/libexec

INSTALL =	/usr/bin/install -c

TESTZONE =	hesiod.test.lysator.liu.se
TESTDATA =	localhost:/export/home/test


all:
	@echo "Valid targets: 'install', 'install-deps', 'clean', 'pull' or 'push'"
	@exit 1

clean:
	-rm -f *~ \#*

check: check-sun check-amd check-hes check-enum

check-sun:
	@echo "Testing Sun-style DNS entry"
	test "`./phealot -Z \"$(TESTZONE)\" -M filsys sun`" = "$(TESTDATA)"

check-amd:
	@echo "Testing AMD-style DNS entry"
	test "`./phealot -Z \"$(TESTZONE)\" -M filsys amd`" = "$(TESTDATA)"

check-hes:
	@echo "Testing Hesiod-style DNS entry"
	test "`./phealot -Z \"$(TESTZONE)\" -M filsys hes`" = "$(TESTDATA)"

check-enum:
	@echo "Testing enumeration of DNS entries"
	./phealot -Z \"$(TESTZONE)\" -M filsys


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
