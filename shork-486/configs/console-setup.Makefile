maindir ?= $(shell pwd)
fntdir  := $(maindir)/Fonts

include rules.mk
include Fonts/Makefile

FONTS := \
	Arabic-Fixed15 \
	Arabic-Fixed16 \
	Armenian-Fixed13 \
	Armenian-Fixed14 \
	Armenian-Fixed16 \
	Armenian-Fixed18 \
	CyrAsia-Fixed13 \
	CyrAsia-Fixed14 \
	CyrAsia-Fixed16 \
	CyrAsia-Fixed18 \
	CyrKoi-Fixed13 \
	CyrKoi-Fixed14 \
	CyrKoi-Fixed16 \
	CyrKoi-Fixed18 \
	CyrSlav-Fixed13 \
	CyrSlav-Fixed14 \
	CyrSlav-Fixed16 \
	CyrSlav-Fixed18 \
	Greek-Fixed13 \
	Greek-Fixed14 \
	Greek-Fixed16 \
	Greek-Fixed18 \
	Georgian-Fixed13 \
	Georgian-Fixed14 \
	Georgian-Fixed16 \
	Georgian-Fixed18 \
	Hebrew-Fixed13 \
	Hebrew-Fixed14 \
	Hebrew-Fixed16 \
	Hebrew-Fixed18 \
	Lao-Fixed14 \
	Lao-Fixed16 \
	Lat2-Fixed13 \
	Lat2-Fixed14 \
	Lat2-Fixed16 \
	Lat2-Fixed18 \
	Lat7-Fixed13 \
	Lat7-Fixed14 \
	Lat7-Fixed16 \
	Lat7-Fixed18 \
	Lat15-Fixed13 \
	Lat15-Fixed14 \
	Lat15-Fixed16 \
	Lat15-Fixed18 \
	Lat38-Fixed13 \
	Lat38-Fixed14 \
	Lat38-Fixed16 \
	Lat38-Fixed18 \
	Thai-Fixed13 \
	Thai-Fixed14 \
	Thai-Fixed16 \
	Thai-Fixed18 \
	Vietnamese-Fixed13 \
	Vietnamese-Fixed14 \
	Vietnamese-Fixed16 \
	Vietnamese-Fixed18 \
	\
	\
	\
	CyrAsia-Terminus14 \
	CyrAsia-Terminus16 \
	CyrKoi-Terminus14 \
	CyrKoi-Terminus16 \
	CyrSlav-Terminus14 \
	CyrSlav-Terminus16 \
	Greek-Terminus14 \
	Greek-Terminus16 \
	Hebrew-Terminus14 \
	Hebrew-Terminus16 \
	Lat2-Terminus14 \
	Lat2-Terminus16 \
	Lat7-Terminus14 \
	Lat7-Terminus16 \
	Lat15-Terminus14 \
	Lat15-Terminus16 \
	Lat38-Terminus14 \
	Lat38-Terminus16 \
	Vietnamese-Terminus14 \
	Vietnamese-Terminus16 \
	\
	\
	\
	Arabic-VGA8 \
	Arabic-VGA14 \
	Arabic-VGA16 \
	CyrKoi-VGA8 \
	CyrKoi-VGA14 \
	CyrKoi-VGA16 \
	CyrSlav-VGA8 \
	CyrSlav-VGA14 \
	CyrSlav-VGA16 \
	Greek-VGA8 \
	Greek-VGA14 \
	Greek-VGA16 \
	Hebrew-VGA8 \
	Hebrew-VGA14 \
	Hebrew-VGA16 \
	Lat2-VGA8 \
	Lat2-VGA14 \
	Lat2-VGA16 \
	Lat7-VGA8 \
	Lat7-VGA14 \
	Lat7-VGA16 \
	Lat15-VGA8 \
	Lat15-VGA14 \
	Lat15-VGA16 \
	Lat38-VGA8 \
	Lat38-VGA14 \
	Lat38-VGA16

fontfiles := $(addprefix $(fntdir)/,$(addsuffix .psf,$(FONTS)))
.PRECIOUS: $(fontfiles)
DESTDIR ?=
consolefontdir := $(DESTDIR)/usr/share/consolefonts

.DEFAULT_GOAL := fonts

.PHONY: fonts
fonts: $(fontfiles)

.PHONY: install
install: fonts
	install -d $(consolefontdir)
	install -m 644 $(fontfiles) $(consolefontdir)
