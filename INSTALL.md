
# Installation

The source file in the Markdown format is converted to PDF in two steps:

1. convert Markdown to HTML
2. convert HTML to PDF

## Markdown to HTML

Markdown is converted to HTML with the help of `kramdown`.
Therefore need to install it with:

```
sudo apt install kramdown
```

## HTML to PDF

HTML is converted to PDF with the help of `chromehtml2pdf` and `chromium`.

`chromehtml2pdf` is a JavaScript library, so first need to prepare
the JS environment:

```
sudo apt install npm
```

Now need to install it using `npm`:

```
npm install chromehtml2pdf
```

After installation, it's suggested to add the path
of its executable to e.g. `~/.profile` as

```
export PATH="$PATH:/.../chromehtml2pdf/node_modules/.bin/"
```

Also it provides the executable of the Chromium browser in
`./node_modules/puppeteer/.local-chromium/linux-686378/chrome-linux/chrome`.
It's an old version that used to work nicely in older settings.
However, in a new environment now it crashes on every HTML page.
So need to install a fresh version of Chromium:

```
sudo apt install chromium
```

Then also set it via a command line switch of `chromehtml2pdf`:

```
--executablePath /usr/bin/chromium
```

## Fonts

Optionally, to get nicer Hebrew fonts, the font could be installed
by the Font manager installed with:

```
sudo apt install font-manager
```

## Exiftool

Optionally, to be able to add more meta-information to PDF
a useful tool is `exiftool` that can be installed with:

```
sudo apt install exiftool
```

or directly with:

```
sudo apt install libimage-exiftool-perl
```
