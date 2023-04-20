#!/usr/bin/env ruby

require 'httparty'
require 'nokogiri'

class Listing
  def initialize(title, img_src, img_alt, details, price, link)
    @title = title
    @img_src = img_src
    @img_alt = img_alt
    @details = details
    @price = price
    @link = link
  end

  def to_s
    "#{title}\n#{details}\n#{price}\n#{link}"
  end

  attr_reader :title, :img_src, :img_alt, :details, :price, :link
end

def doneDealScraper
  url = 'https://www.donedeal.ie/cars?sort=publishdatedesc&country=Ireland&year_from=2011&price_from=1000&price_to=12000'
  response = HTTParty.get(url)
  puts "Status: #{response.code}\n"
  page = Nokogiri::HTML(response.body)

  cards = page.css('li[class^="Listings__Desktop"]')
  cards.each do |card|
    link = card.at('a[class^="Link__SLinkButton"]')
    # skip ads without real links
    next unless link

    link = link['href']

    title = card.css('p[class^="Card__Title"]').text

    image_src = card.css('img')[0]['src']
    image_alt = card.css('img')[0]['alt']

    li_elements = card.css('ul[class^="Card__KeyInfoList"] li')

    li_text_array = li_elements.map { |li| li.text.strip }

    price = card.css('p[class^="Card__InfoText"]').text[/\A€\d+(,\d{3})*(\.\d{1,2})?\b/]

    puts Listing.new(title, image_src, image_alt, li_text_array, price, link)
    puts "\n\n"
  end
end

doneDealScraper
