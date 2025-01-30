#!/usr/bin/env ruby

# ruby comments_html.rb < ru/book/202501/uriel.html > ru/book/202501/uriel_with_comments.html

input = ARGF.read
output = input.gsub(/<p>{OPEN}<\/p>\n([^{}]+?)\n<p>{CLOSE}<\/p>/m) do |_match|
  content = $1
  open_p = content =~ /id="postmodern"|id="typography"/ ? 'true' : 'false'
  <<-HTML.chomp
<div class="comments" x-show="buttons" x-data="{ open: #{open_p} }"><button @click="open = !open">…</button><div class="comment hidden" :class="{ \'hidden\': !open && !openall }">#{content}</div></div>
HTML
end.gsub(/{OPEN}(.+?){CLOSE}/m,
  '<span class="comments" x-show="buttons" x-data="{ open: false }"><button @click="open = !open">…</button><span class="comment hidden" :class="{ \'hidden\': !open && !openall }">\1</span></span>')

print output
