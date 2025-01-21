#!/usr/bin/env ruby

# ruby comments_md.rb < uriel.md > uriel_with_comments.md

input = ARGF.read
output = input.gsub(/<!--(.+?)-->/m) do |_match|
  content = $1.strip
  b, e = Regexp.last_match.begin(0), Regexp.last_match.end(0)
  paragraph_p = input[b-2 .. b-1] == "\n\n" && input[e .. e+1] == "\n\n"
  paragraph_p ? "{OPEN}\n\n#{content}\n\n{CLOSE}" : "{OPEN}#{content}{CLOSE}"
end

print output
