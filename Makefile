# Copyright (C) 2018-2024  Judka Linkov <judka@uriel.world>
# This file is free software; see GNU GPL v3 for copying conditions.

# Installation:
# sudo apt install kramdown
# sudo apt install nodejs npm
# npm install chromehtml2pdf
# sudo apt install libimage-exiftool-perl

# source files
SRCFILES = uriel.md

# base filename
URIEL      = uriel
# html output
URIEL_HTML  = html/$(URIEL).html
# pdf output
URIEL_PDF  = html/$(URIEL).pdf

ROOTDIR = $(realpath .)

default: pdf
all: pdf

html: $(URIEL_HTML)
$(URIEL_HTML): $(SRCFILES) html/header.html html/footer.html Makefile
	convert -size 320x200 xc:gray +noise random -colorspace gray images/white_noise.jpg
	LANG=en_US.UTF-8 kramdown $(SRCFILES) \
	| cat html/header.html - html/footer.html \
	> $(URIEL_HTML)

pdf: $(URIEL_PDF)
$(URIEL_PDF): $(URIEL_HTML) Makefile
	chromehtml2pdf \
	--format=A4 \
	--displayHeaderFooter=true \
	--headerTemplate='<div></div>' \
	--footerTemplate='<style type="text/css">.pdf-footer { font-size: 10px; font-weight: bold; font-style: italic; width: 100%; text-align: center; color: lightgrey; padding-right: 1cm; }</style><div class="pdf-footer"><span class="pageNumber"></span></div>' \
	--out=$(URIEL_PDF) \
	file://$(ROOTDIR)/$(URIEL_HTML)
	exiftool -e -overwrite_original -P -PDF:Author="Judka Linkov" -PDF:Title="Uriel" -PDF:Subject="Non-Orthodox Judaism" -PDF:Keywords="judaism, light" $(URIEL_PDF)
