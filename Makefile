# Copyright (C) 2018-2024 Judka Linkov <judka@uriel.world>
# This file is free software; see GNU GPL v3 for copying conditions.

# Installation:
# sudo apt install kramdown
# sudo apt install nodejs npm
# npm install chromehtml2pdf
# sudo apt install libimage-exiftool-perl

# source files
SRCFILES = uriel.md

SUBDIR     = $(shell date +%Y%m)
URIEL_HTML = ru/book/$(SUBDIR)/uriel.html
URIEL_PDF  = files/book/$(SUBDIR)/Uriel.pdf

ROOTDIR = $(realpath .)

default: pdf
all: pdf

$(dir $(URIEL_HTML)):
	mkdir -p $@

html: $(URIEL_HTML)
$(URIEL_HTML): $(SRCFILES) files/book/header.html files/book/footer.html Makefile $(dir $(URIEL_HTML))
#	convert -size 320x200 xc:gray +noise random -colorspace gray images/white_noise.jpg
	LANG=en_US.UTF-8 kramdown $(SRCFILES) \
	| cat files/book/header.html - files/book/footer.html \
	> $@

$(dir $(URIEL_PDF)):
	mkdir -p $@

pdf: $(URIEL_PDF)
$(URIEL_PDF): $(URIEL_HTML) Makefile $(dir $(URIEL_PDF))
	chromehtml2pdf \
	--executablePath /usr/bin/chromium \
	--format=A4 \
	--displayHeaderFooter=true \
	--headerTemplate='<div></div>' \
	--footerTemplate='<style type="text/css">.pdf-footer { font-size: 15px; font-weight: bold; font-style: italic; width: 100%; text-align: center; color: lightgrey; }</style><div class="pdf-footer"><span class="pageNumber"></span></div>' \
	--out=$@ \
	file://$(ROOTDIR)/$(URIEL_HTML)
	exiftool -e -overwrite_original -P -PDF:Author="(C) 2018-2024 Judka Linkov CC-BY-4.0" -PDF:Title="Uriel" -PDF:Subject="Non-Orthodox Judaism" -PDF:Keywords="judaism, light" $(URIEL_PDF)
