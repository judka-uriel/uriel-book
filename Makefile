# Copyright (C) 2018-2025 Judka Linkov <judka@uriel.world>
# This file is free software; see GNU GPL v3 for copying conditions.

# Installation:
# sudo apt install kramdown
# sudo apt install nodejs npm
# npm install chromehtml2pdf
# sudo apt install libimage-exiftool-perl

ROOT_DIR   = $(realpath .)
OUT_SUBDIR = $(shell date +%Y%m)

URIEL_RU_MD   = uriel.md
URIEL_RU_HTML = ru/book/$(OUT_SUBDIR)/uriel.html
URIEL_RU_PDF  = files/book/ru/$(OUT_SUBDIR)/Uriel_ru.pdf
URIEL_RU_EPUB = files/book/ru/$(OUT_SUBDIR)/Uriel_ru.epub

URIEL_RU_C_HTML = ru/book/$(OUT_SUBDIR)/uriel_with_comments.html
URIEL_RU_C_PDF  = files/book/ru/$(OUT_SUBDIR)/Uriel_with_comments_ru.pdf

URIEL_EN_MD   = uriel_en.md
URIEL_EN_HTML = en/book/$(OUT_SUBDIR)/uriel.html
URIEL_EN_PDF  = files/book/en/$(OUT_SUBDIR)/Uriel_en.pdf
URIEL_EN_EPUB = files/book/en/$(OUT_SUBDIR)/Uriel_en.epub

URIEL_EN_C_HTML = en/book/$(OUT_SUBDIR)/uriel_with_comments.html
URIEL_EN_C_PDF  = files/book/en/$(OUT_SUBDIR)/Uriel_with_comments_en.pdf

all: $(URIEL_RU_PDF) $(URIEL_EN_PDF) $(URIEL_RU_C_HTML) $(URIEL_EN_C_HTML)
# optional: $(URIEL_RU_C_PDF) $(URIEL_EN_C_PDF)
epub: $(URIEL_RU_EPUB) $(URIEL_EN_EPUB)

# 1.1. generate PDF (ru)

$(dir $(URIEL_RU_HTML)):
	mkdir -p $@

$(URIEL_RU_HTML): $(URIEL_RU_MD) files/book/style.css files/book/header.html files/book/footer.html Makefile $(dir $(URIEL_RU_HTML))
#	convert -size 320x200 xc:gray +noise random -colorspace gray images/white_noise.jpg
	LANG=en_US.UTF-8 kramdown $< \
	| cat files/book/header.html - files/book/footer.html \
	> $@

$(dir $(URIEL_RU_PDF)):
	mkdir -p $@

$(URIEL_RU_PDF): $(URIEL_RU_HTML) files/book/print.css $(dir $(URIEL_RU_PDF))
	chromehtml2pdf \
	--executablePath /usr/bin/chromium \
	--format=A4 \
	--displayHeaderFooter=true \
	--headerTemplate='<div></div>' \
	--footerTemplate='<style type="text/css">.pdf-footer { font-size: 15px; font-weight: bold; font-style: italic; width: 100%; text-align: center; color: lightgrey; }</style><div class="pdf-footer"><span class="pageNumber"></span></div>' \
	--out=$@ \
	file://$(ROOT_DIR)/$<
	exiftool -e -overwrite_original -P -PDF:Author="(C) 2018-2025 Judka Linkov CC BY 4.0" -PDF:Title="Uriel" -PDF:Subject="Non-Orthodox Judaism" -PDF:Keywords="judaism, light" $@
	touch -r $@ $(dir $@)

# 1.2. generate HTML with comments (ru)

$(URIEL_RU_C_HTML): $(URIEL_RU_MD) comments_md.rb comments_html.rb files/book/style.css files/book/header.html files/book/footer.html Makefile $(dir $(URIEL_RU_C_HTML))
	LANG=en_US.UTF-8 ruby comments_md.rb $< \
	| LANG=en_US.UTF-8 kramdown \
	| LANG=en_US.UTF-8 ruby comments_html.rb \
	| cat files/book/header.html - files/book/footer.html \
	> $@

$(URIEL_RU_C_PDF): $(URIEL_RU_C_HTML) files/book/print.css $(dir $(URIEL_RU_C_PDF))
	chromehtml2pdf \
	--executablePath /usr/bin/chromium \
	--format=A4 \
	--displayHeaderFooter=true \
	--headerTemplate='<div></div>' \
	--footerTemplate='<style type="text/css">.pdf-footer { font-size: 15px; font-weight: bold; font-style: italic; width: 100%; text-align: center; color: lightgrey; }</style><div class="pdf-footer"><span class="pageNumber"></span></div>' \
	--out=$@ \
	file://$(ROOT_DIR)/$<
	exiftool -e -overwrite_original -P -PDF:Author="(C) 2018-2025 Judka Linkov CC BY 4.0" -PDF:Title="Uriel" -PDF:Subject="Non-Orthodox Judaism" -PDF:Keywords="judaism, light" $@
	touch -r $@ $(dir $@)

# 1.3. generate EPUB (ru)

$(URIEL_RU_EPUB): $(URIEL_RU_MD) files/book/epub.css Makefile $(dir $(URIEL_RU_EPUB))
	LANG=en_US.UTF-8 ruby epub_md.rb $< \
	| pandoc -o $@ --css=files/book/epub.css --toc --toc-depth=1 --epub-subdirectory=OEBPS --epub-cover-image=files/book/cover.jpg -
	ruby epub_fix.rb $@
#	zipgrep "." $@ > $@.txt

# 2.1. generate PDF (en)

$(dir $(URIEL_EN_HTML)):
	mkdir -p $@

$(URIEL_EN_HTML): $(URIEL_EN_MD) files/book/style.css files/book/header.html files/book/footer.html Makefile $(dir $(URIEL_EN_HTML))
#	convert -size 320x200 xc:gray +noise random -colorspace gray images/white_noise.jpg
	LANG=en_US.UTF-8 kramdown $< \
	| cat files/book/header.html - files/book/footer.html \
	| LANG=en_US.UTF-8 ruby -pe 'sub(%q{<html lang="ru">}, %q{<html lang="en-US">})' \
	| LANG=en_US.UTF-8 ruby -pe 'sub("font-size: 120", "font-size: 124")' \
	> $@

$(dir $(URIEL_EN_PDF)):
	mkdir -p $@

$(URIEL_EN_PDF): $(URIEL_EN_HTML) files/book/print.css $(dir $(URIEL_EN_PDF))
	chromehtml2pdf \
	--executablePath /usr/bin/chromium \
	--format=A4 \
	--displayHeaderFooter=true \
	--headerTemplate='<div></div>' \
	--footerTemplate='<style type="text/css">.pdf-footer { font-size: 15px; font-weight: bold; font-style: italic; width: 100%; text-align: center; color: lightgrey; }</style><div class="pdf-footer"><span class="pageNumber"></span></div>' \
	--out=$@ \
	file://$(ROOT_DIR)/$<
	exiftool -e -overwrite_original -P -PDF:Author="(C) 2018-2025 Judka Linkov CC BY 4.0" -PDF:Title="Uriel" -PDF:Subject="Non-Orthodox Judaism" -PDF:Keywords="judaism, light" $@
	touch -r $@ $(dir $@)

# 2.2. generate HTML with comments (en)

$(URIEL_EN_C_HTML): $(URIEL_EN_MD) comments_md.rb comments_html.rb files/book/style.css files/book/header.html files/book/footer.html Makefile $(dir $(URIEL_EN_C_HTML))
	LANG=en_US.UTF-8 ruby comments_md.rb $< \
	| LANG=en_US.UTF-8 kramdown \
	| LANG=en_US.UTF-8 ruby comments_html.rb \
	| cat files/book/header.html - files/book/footer.html \
	| LANG=en_US.UTF-8 ruby -pe 'sub(%q{<html lang="ru">}, %q{<html lang="en-US">})' \
	> $@

# 2.3. generate EPUB (en)

$(URIEL_EN_EPUB): $(URIEL_EN_MD) files/book/epub.css Makefile $(dir $(URIEL_EN_EPUB))
	LANG=en_US.UTF-8 ruby epub_md.rb $< \
	| pandoc -o $@ --css=files/book/epub.css --toc --toc-depth=1 --epub-subdirectory=OEBPS -
	ruby epub_fix.rb $@
#	zipgrep "." $@ > $@.txt
