#!/usr/bin/env ruby
# coding: utf-8

require "nokogiri"
require "uri"
require "net/http"

def get(uri)
  response = Net::HTTP.get_response(URI.parse(uri))
  unless response.code == "200"
    fail "failed to download #{uri}"
  end
  response.body
end

def download(uri, path)
  open(path, "wb") do |output|
    data = get(uri)
    output.write(data)
  end
end

def find_title(html)
  title = html.css("h2").first.content rescue nil
  if title.nil? || title == "More Like This"
    html.css("h1").first.content
  else
    title
  end
end

def get_base_image_url(html)
  first_thumbnail_href = html.css(".gallerythumb")[0].attributes["href"].to_s
  html_text = get("https://nhentai.net#{first_thumbnail_href}")
  first_page_dom = Nokogiri::HTML(html_text)
  first_image_url = first_page_dom.css("#image-container img").first.attributes["src"].to_s rescue nil
  first_image_url.sub(/\/1\.[A-z]+$/, '')
end

def get_image_url(base_url, thumbnail_img_src)
  thumbnail_img_src.sub(%r{/([0-9]+)t\.([a-z]+)$}, "")
  image_number = Regexp.last_match[1].to_i
  image_extension = Regexp.last_match[2]
  "#{base_url}/#{image_number}.#{image_extension}"
end

html_text = get(ARGV[0])
html = Nokogiri::HTML(html_text)
title = find_title(html)
puts "title: #{title}"

title.gsub!(/[\\\/:\*\?"<>|]+/, "_")
Dir.mkdir(title) unless Dir.exist?(title)
Dir.chdir(title) do
  base_url = get_base_image_url html
  html.css(".gallerythumb>.lazyload").each do |thumbnail_img|
    thumbnail_img_src = thumbnail_img.attributes["data-src"].to_s
    match = thumbnail_img_src.match %r{/([0-9]+)t\.([a-z]+)$}
    image_number = match[1].to_i
    image_extension = match[2]
    image_url = "#{base_url}/#{image_number}.#{image_extension}"
    local_image_path = "%03d.%s" % [image_number, image_extension]
    next if File.exist? local_image_path
    puts "downloading #{image_url}"
    begin
      download image_url, local_image_path
    rescue Interrupt => e
      File.delete local_image_path
      break
    rescue => e
      File.delete local_image_path
      raise e
    end
  end
end

print "\a"
