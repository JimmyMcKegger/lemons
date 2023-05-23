# frozen_string_literal: true

class Listing
  def initialize(title, img_src, img_alt, price, link, year, engine, mileage, posted, county)
    @title = title
    @img_src = img_src
    @img_alt = img_alt
    @price = price
    @link = link
    @year = year
    @engine = engine
    @mileage = mileage
    @posted = posted
    @county = county
  end

  def to_s
    "#{title}\n#{year}, #{engine}\n#{mileage}\n#{price}\n#{link}"
  end

  attr_accessor :title, :img_src, :img_alt, :price, :link, :year, :engine, :mileage, :posted, :county
end
