# Copyright (C) 2018-2025 Judka Linkov <judka@uriel.world>
# This file is free software; see GNU GPL v3 for copying conditions.

# Installation:
# sudo apt install kramdown
# sudo apt install nodejs npm
# npm install chromehtml2pdf
# sudo apt install libimage-exiftool-perl

ROOT_DIR   = $(realpath .)
OUT_SUBDIR = $(shell date +%Y%m)

URIEL_MD   = uriel.md
URIEL_HTML = ru/book/$(OUT_SUBDIR)/uriel.html
URIEL_PDF  = files/book/$(OUT_SUBDIR)/Uriel.pdf

URIEL_C_HTML = ru/book/$(OUT_SUBDIR)/uriel_with_comments.html
URIEL_C_PDF  = files/book/$(OUT_SUBDIR)/Uriel_with_comments.pdf

all: $(URIEL_PDF) $(URIEL_C_HTML) # $(URIEL_C_PDF)

# 1. generate PDF

$(dir $(URIEL_HTML)):
	mkdir -p $@

$(URIEL_HTML): $(URIEL_MD) files/book/style.css files/book/header.html files/book/footer.html Makefile $(dir $(URIEL_HTML))
#	convert -size 320x200 xc:gray +noise random -colorspace gray images/white_noise.jpg
	LANG=en_US.UTF-8 kramdown $< \
	| cat files/book/header.html - files/book/footer.html \
	> $@

$(dir $(URIEL_PDF)):
	mkdir -p $@

$(URIEL_PDF): $(URIEL_HTML) files/book/print.css $(dir $(URIEL_PDF))
	chromehtml2pdf \
	--executablePath /usr/bin/chromium \
	--format=A4 \
	--displayHeaderFooter=true \
	--headerTemplate='<div></div>' \
	--footerTemplate='<style type="text/css">.pdf-footer { font-size: 15px; font-weight: bold; font-style: italic; width: 100%; text-align: center; color: lightgrey; }</style><div class="pdf-footer"><span class="pageNumber"></span></div>' \
	--out=$@ \
	file://$(ROOT_DIR)/$<
	exiftool -e -overwrite_original -P -PDF:Author="(C) 2018-2025 Judka Linkov CC-BY-4.0" -PDF:Title="Uriel" -PDF:Subject="Non-Orthodox Judaism" -PDF:Keywords="judaism, light" $@
	touch -r $@ $(dir $@)

# 2. generate HTML with comments

$(URIEL_C_HTML): $(URIEL_MD) comments_md.rb comments_html.rb files/book/style.css files/book/header.html files/book/footer.html Makefile $(dir $(URIEL_C_HTML))
	LANG=en_US.UTF-8 ruby comments_md.rb $< \
	| LANG=en_US.UTF-8 kramdown \
	| LANG=en_US.UTF-8 ruby comments_html.rb \
	| cat files/book/header.html - files/book/footer.html \
	> $@

$(URIEL_C_PDF): $(URIEL_C_HTML) files/book/print.css $(dir $(URIEL_C_PDF))
	chromehtml2pdf \
	--executablePath /usr/bin/chromium \
	--format=A4 \
	--displayHeaderFooter=true \
	--headerTemplate='<div></div>' \
	--footerTemplate='<style type="text/css">.pdf-footer { font-size: 15px; font-weight: bold; font-style: italic; width: 100%; text-align: center; color: lightgrey; }</style><div class="pdf-footer"><span class="pageNumber"></span></div>' \
	--out=$@ \
	file://$(ROOT_DIR)/$<
	exiftool -e -overwrite_original -P -PDF:Author="(C) 2018-2025 Judka Linkov CC-BY-4.0" -PDF:Title="Uriel" -PDF:Subject="Non-Orthodox Judaism" -PDF:Keywords="judaism, light" $@
	touch -r $@ $(dir $@)
