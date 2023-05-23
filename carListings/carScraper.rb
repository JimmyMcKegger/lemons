#!/usr/bin/env ruby
# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require 'pry'

require_relative 'listing'
require_relative 'counties'
require_relative 'km_convert'

def done_deal_scraper
  url = 'https://www.donedeal.ie/cars?sort=publishdatedesc&country=Ireland&year_from=2012&price_from=1000&price_to=12000'
  response = HTTParty.get(url)
  puts "Status: #{response.code}\n"
  page = Nokogiri::HTML(response.body)

  cards = page.css('li[class^="Listings__Desktop"]')
  cards.each do |card|
    link = card.at('a[class^="Link__SLinkButton"]')
    # skips ads without real links
    next unless link

    link = link['href']

    title = card.css('p[class^="Card__Title"]').text

    # image
    if card.css('img').empty?
      image_src = ''
      image_alt = ''
    else
      image_src = card.css('img')[0]['src']
      image_alt = card.css('img')[0]['alt']
    end

    li_elements = card.css('ul[class^="Card__KeyInfoList"] li')

    year, engine, mileage, posted, county = li_elements.map { |li| li.text.strip }

    mileage = km_convert(mileage) if mileage =~ /mi\z/

    price = card.css('p[class^="Card__InfoText"]').text[/\A€\d+(,\d{3})*(\.\d{1,2})?\b/]

    puts Listing.new(title, image_src, image_alt, price, link, year, engine, mileage, posted, county)
    puts "\n\n"
  end
end

done_deal_scraper
