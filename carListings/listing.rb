# frozen_string_literal: true

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

  attr_accessor :title, :img_src, :img_alt, :details, :price, :link
end
