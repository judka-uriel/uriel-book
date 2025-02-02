#!/usr/bin/env ruby

# ruby comments_html.rb < ru/book/202501/uriel.html > ru/book/202501/uriel_with_comments.html

input = ARGF.read
output = input.gsub(/<p>{OPEN}<\/p>\n([^{}]+?)\n<p>{CLOSE}<\/p>/m) do |_match|
  content = $1
  open_p = content =~ /id="postmodern"|id="typography"/ ? 'true' : 'false'
  <<-HTML.chomp
<template x-if="buttons"><div class="comments" x-data="{ open: #{open_p} }"><button @click="open = !open" @openall.window="open = true">…</button><div class="comment" x-show="open">#{content}</div></div></template>
HTML
end.gsub(/{OPEN}(.+?){CLOSE}/m,
  '<template x-if="buttons"><span class="comments" x-data="{ open: false }"><button @click="open = !open" @openall.window="open = true">…</button><span class="comment" x-show="open">\1</span></span></template>')

print output
