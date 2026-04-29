#!/usr/bin/env ruby

# sudo apt install ruby-zip
require 'zip'
require 'fileutils'
require 'tempfile'

def epub_fix(epub_path, ru)
  temp_file = Tempfile.new(['fixed_epub', '.epub'])
  temp_path = temp_file.path
  temp_file.close

  Zip::File.open(epub_path) do |input_zip|
    Zip::File.open(temp_path, Zip::File::CREATE) do |output_zip|
      input_zip.each do |entry|
        content = entry.get_input_stream.read
        content = content.force_encoding('UTF-8') if content.encoding == Encoding::ASCII_8BIT
        if entry.name =~ /container\.xml/
          content.gsub!('EPUB/', 'OEBPS/')
        elsif entry.name =~ /content\.opf/
          # TODO: Move TOC to the end (only on the site)
          # content.sub!(%r{<itemref idref="nav" />\n?}i, '')
          # content.sub!(%r{</spine>}i, "  <itemref idref=\"nav\" />\n  </spine>")
        elsif entry.name =~ /nav\.xhtml/
          unless ru
            content.sub!('<h1 id="toc-title">Uriel</h1>', '<h1 id="toc-title">Table of Contents</h1>')
          else
            content.sub!('<h1 id="toc-title">Уриэль</h1>', '<h1 id="toc-title">Оглавление</h1>')
          end
        elsif entry.name =~ /title_page\.xhtml/
          content.gsub!(%r{<(?:h1|p) class=([^<]*)</(?:h1|p)>}i, "<div class=\\1</div>")
        elsif entry.name =~ /\.xhtml?$/i
          content.gsub!(%r{<h1>.*?</h1>\n?}i) do |match|
            ''
          end
          content.gsub!(%r{<figcaption(.*?)>(.*?)</figcaption>}i) do |match|
            attrs, text = $1, $2
            unless ru
              replacement = "<figcaption#{attrs}>" + (text =~ /light|Tafilia/i ? text : '') + '</figcaption>'
            else
              replacement = "<figcaption#{attrs}>" + (text =~ /light|Тафилия/i ? text : '') + '</figcaption>'
            end
            replacement
          end
        end
        output_zip.get_output_stream(entry.name.sub('EPUB/', 'OEBPS/')) { |f| f.write(content) }
      end
    end
  end

  FileUtils.mv(temp_path, epub_path)
end

ru = ARGV.delete('--ru')

if ARGV.length != 1
  puts "Usage: ruby epub_fix.rb file.epub"
  exit 1
end

epub_file = ARGV[0]

unless File.exist?(epub_file)
  puts "Error: File '#{epub_file}' not found"
  exit 1
end

epub_fix(epub_file, ru)
