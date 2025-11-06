PREFIX ?= /usr/
DATA_DIR ?= $(PREFIX)/share/

core:
	install -dDm0755 $(DESTDIR)/$(DATA_DIR)/wireplumber/wireplumber.conf.d/
	install -pm644 conf/wireplumber.conf $(DESTDIR)/$(DATA_DIR)/wireplumber/wireplumber.conf.d/99-audio-enhancements.conf

latitude-7440: core
	install -dDm0755 $(DESTDIR)/$(DATA_DIR)/audio-enhancements/latitude-7440/
	install -pm0644 -t $(DESTDIR)/$(DATA_DIR)/audio-enhancements/latitude-7440/ $(wildcard irs/latitude-7440/*)

install: core latitude-7440

uninstall:
	rm -rf $(DESTDIR)/$(DATA_DIR)/wireplumber/wireplumber.conf.d/99-audio-enhancements.conf
	rm -rf $(DESTDIR)/$(DATA_DIR)/audio-enhancements/