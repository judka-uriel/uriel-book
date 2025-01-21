#!/usr/bin/env ruby

# ruby comments_html.rb < ru/book/202501/uriel.html > ru/book/202501/uriel_with_comments.html

input = ARGF.read
output = input
           .gsub(
             /<p>{OPEN}<\/p>\n([^{}]+?)\n<p>{CLOSE}<\/p>/m,
             '<div class="comments" x-data="{ open: false }"><button @click="open = !open">…</button><div class="comment hidden" :class="{ \'hidden\': !open }">\1</div></div>')
           .gsub(
             /{OPEN}(.+?){CLOSE}/m,
             '<span class="comments" x-data="{ open: false }"><button @click="open = !open">…</button><span class="comment hidden" :class="{ \'hidden\': !open }">\1</span></span>')

print output
