#!/usr/bin/env ruby

md = ARGV.sort.map { |file| File.read(file) }.join

md.gsub!(%r{{::comment}.*?{:/comment}}m, '')

md.gsub!(/(\s*)<!--.*?-->(\s*)/m) do |_match|
  pre, post = $1, $2
  if pre =~ /\A\n\n+\Z/ && post =~ /\A\n\n+\Z/
    post
  elsif pre =~ /\A\n\n\Z/ && post =~ /\A +\Z/
    pre
  elsif pre =~ /\A +\Z/ && post =~ /\A\n\n\Z/
    post
  elsif pre =~ /\A\n\n\Z/ && post =~ /\A\n\Z/
    pre
  elsif pre =~ /\A\n\Z/ && post =~ /\A\n\n\Z/
    post
  elsif pre =~ /\A\n\Z/ && post =~ /\A\n\Z/
    post
  elsif pre =~ /\A +\Z/ && post =~ /\A\n\Z/
    post
  elsif pre =~ /\A\n\Z/ && post =~ /\A +\Z/
    pre
  elsif pre =~ /\A\n +\Z/ && post =~ /\A\n\n?\Z/
    post
  elsif pre =~ /\A +\Z/ && post =~ /\A +\Z/
    post
  elsif pre =~ /\A\Z/ && post =~ /\A\n\n\Z/
    "\n"
  elsif pre =~ /\A\Z/ && post =~ /\A\n\Z/
    ''
  else
    pre + post
  end
end

md.gsub!(/\n\n\n+/, "\n\n")

# Handle balanced parens in urls
md.gsub!(%r{\[([^\]]+)\]\(https://[^)(]*(?:[^)(]*|(\((?>[^)(]+|\g<2>)*\)))[^)(]*\)}m, '\1')
md.gsub!(/ /, ' ') # PUNCTUATION SPACE in links
md.gsub!(/ /, ' ') # EN SPACE in lists

# Match paragraphs with trailing info
md.gsub!(/(\n\n(?:[^\n][\n]?)+)^({:[^}]+}\n?)/) do |_match|
  re = /#([a-z-]+) title="([^"]+)" */
  para, info = $1, $2
  id, title = info.match(re)&.captures
  if (id && title)
    info.sub!(re, '')
    info = '' if info =~ /{: *}/
    "\n\n# #{title}#{para}#{info}"
  else
    "#{para}#{info}"
  end
end

md.gsub!(/^### (.+?)$/, '## \1')
md.gsub!(/^\| *([^\|\n]*?) *\| *([^\|\n]*?) *\|\n\| *([^\|\n]*?) *\| *([^\|\n]*?) *\|$/, '## \1 \4')
md.gsub!(/^\| *([^\|\n]*?) *\|\n\| *([^\|\n]*?) *\|$/, '## \1 \2')
md.gsub!(/^\| *([^\|\n]*?) *\| *([^\|\n]*?) *\|$/, '## \1')
md.gsub!(/^\| *([^\|\n]*?) *\|$/, '## \1')

# Remove remaining kramdown specific tags
md.gsub!(/^{:[^}]*}\n/, '')
md.gsub!(/{:\.center}/, '')

md.gsub!('<br />', '')

md.gsub!('רז', '*raz*')
md.gsub!('מאור', '*maor*')
md.gsub!('אור', '*Ohr*')
md.gsub!('רמז (*remez*)', '*remez*')
md.gsub!("מלאך (*mal'akh*)", "*mal'akh*")
md.gsub!(/Satan \([^\)]+\) is an/, 'Satan is an')
md.gsub!(/accuse the priest \([^\)]+\)/, 'accuse the priest')
md.gsub!(/gematria of the word \*SATAN\* \([^\)]+\)/, 'gematria of the word *SATAN*')
md.gsub!('**ש**', '*shin*')
md.gsub!(/:\n\n> \(Devarim 7:3-4\).*\n\nLiterally, this translates/m, "\nof Devarim 7:3-4 that literally are translated")
md.gsub!(/ז״ל/, 'z"l')

md.gsub!(%r{../../../files/book/}, './files/book/')
md.sub!("\n  and his sister", ' and his sister')
md.gsub!(%r{<figure>\s*<img src="([^"]*)" alt="(?:[^"]*)" />\s*<figcaption>([^<]*)</figcaption>\s*</figure>}m) do |_match|
  "![#{$2}](#{$1})"
end

md.sub!(%r{\n<div class="title-page">.*<div class="year">([^<]+)</div>.*</div>}m, '## \1')

md.gsub!(/\s*—\s*/, '—')
md.gsub!(/([”])([,.])/, '\2\1')

md.sub!(/\A\n/, <<~HEREDOC)
---
title:
- type: main
  text: Uriel
- type: subtitle
  text: Looking at the world through the prism of Judaism
author: Judka Linkov
rights: © 2025 CC BY 4.0
language: en-US
description: |
    Do you want to know how our world works?
    Why has the world not yet reached perfection?
    Why does evil exist in the world?
    How to correct the imbalance of extremes?
    What can be done to achieve peace in the world?
    What awaits humanity in the near future if people do not correct themselves?
    The answers to these questions from the perspective of
    Torah, Kabbalah and science are revealed in this book.
---
HEREDOC

puts md
