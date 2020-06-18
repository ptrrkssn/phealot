# Makefile for phealot

DESTDIR =
PREFIX = 	/usr

prefix =	$(PREFIX)
libexecdir =	${prefix}/libexec
man8dir = 	${prefix}/share/man/man8

INSTALL =	/usr/bin/install -c

# A DNS zone containing test data for this tool
TESTZONE =	hesiod.test.lysator.liu.se
TESTDATA =	localhost:/export/home/test

all:
	@echo "Valid targets: 'install', 'install-deps', 'clean', 'pull' or 'push'"
	@exit 1

clean:
	-rm -f *~ \#*


check: check-start check-sun check-amd check-hes check-list
	@echo "All checks passed."

check-start:
	@echo "Running checks:"

check-sun:
	@test "`./phealot -Z $(TESTZONE) -M filsys sun`" = "$(TESTDATA)"
	@if test $$? = 0; then \
	  echo "+ Sun-style map lookup OK"; \
	else \
	  echo "- Sun-style map lookup Failed"; \
	fi

check-amd:
	@test "`./phealot -Z $(TESTZONE) -M filsys amd`" = "$(TESTDATA)"
	@if test $$? = 0; then \
	  echo "+ AMD-style map lookup OK"; \
	else \
	  echo "- AMD-style map lookup Failed"; \
	fi

check-hes:
	@test "`./phealot -Z $(TESTZONE) -M filsys hes`" = "$(TESTDATA)"
	@if test $$? = 0; then \
	  echo "+ Hesiod-style map lookup OK"; \
	else \
	  echo "- Hesiod-style map lookup Failed"; \
	fi

check-list:
	@test "`./phealot -Z $(TESTZONE) -M filsys|sort|tr '\t\n' ' ;'`" = "amd $(TESTDATA);hes $(TESTDATA);sun $(TESTDATA);"
	@if test $$? = 0; then \
	  echo "+ Map enumeration OK"; \
	else \
	  echo "- Map enumeration Failed"; \
	fi


install: install-bin install-man

install-bin: phealot
	$(INSTALL) -d "$(DESTDIR)${libexecdir}"
	$(INSTALL) phealot "$(DESTDIR)${libexecdir}"

install-man: phealot.8
	$(INSTALL) -d "$(DESTDIR)${man8dir}"
	$(INSTALL) phealot.8 "$(DESTDIR)${man8dir}"

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
