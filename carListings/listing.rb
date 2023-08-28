# frozen_string_literal: true

require_relative 'counties'

class Listing
  include Counties

  @@weights = {
    make: 0.2,
    model: 0.2,
    year: 0.5,
    mileage: 0.4,
    price: 0.6,
    engine: 0.2,
    county: 0.2
  }

  IDEAL_ENGINE_RANGE = (1.2..1.6).freeze

  def initialize(title, img_src, img_alt, price, link, year, engine, mileage, posted, county)
    @title = title
    @img_src = img_src
    @img_alt = img_alt
    @price = price.gsub(/[^\d]/, '').to_i
    @link = link
    @year = year.to_i
    @engine_size, @engine_type = parse_engine(engine)
    @mileage = adjust_mileage(mileage)
    @posted = posted
    @county = parse_county(county)
    @rank = calculate_rank
  end

  def to_s
    "Rank: #{rank}\n#{title}\n#{year}, #{engine_size} #{engine_type}\n#{formatted_mileage}\n#{formatted_price}\n#{county}\n#{link}\n"
  end

  def calculate_rank
    @rank = (@year * @@weights[:year]) +
            ((1_000_000 - raw_milage) * @@weights[:mileage]) +
            (price_weight * @@weights[:price]) +
            (engine_weight * @@weights[:engine]) +
            (county_weight * @@weights[:county])
  end

  private

  def parse_engine(engine)
    engine_parts = engine.split(' ')
    size = engine_parts.first.to_f
    type = engine_parts[1..].join(' ')
    [size, type]
  end

  def adjust_mileage(mileage)
    kms = mileage.scan(/\d+/).join('').to_i
    adjusted_kms = kms < 1000 ? kms * 1000 : kms
    "#{adjusted_kms.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse} km"
  end

  def formatted_price
    "€#{@price.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
  end

  def formatted_mileage
    @mileage.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def raw_milage
    mileage.scan(/\d+/).join('').to_i
  end

  def year_weight
    if @year > 2013
      1.0
    else
      1.0 - (0.03 * (2013 - @year))
    end
  end

  def price_weight
    1.0 - (Math.log(@price + 1) / Math.log(10_000))
  end

  def engine_weight
    if IDEAL_ENGINE_RANGE.include?(@engine_size)
      1.0
    elsif @engine_size < IDEAL_ENGINE_RANGE.begin
      1.0 - (IDEAL_ENGINE_RANGE.begin - @engine_size) * 0.2
    elsif @engine_size > IDEAL_ENGINE_RANGE.end
      1.0 - (@engine_size - IDEAL_ENGINE_RANGE.end) * 0.2
    end
  end

  def county_weight
    sligo_counties = %(Sligo Mayo Leitrim Donegal)
    if sligo_counties.include?(@county)
      1.0
    else
      1.0 - (0.1 * 0 - Counties.distance_from_home(@county)).abs
    end
  end

  def parse_county(county)
    if county =~ /^Co.\s?.*/i
      county.split("\s").last
    else
      'Dublin'
    end
  end

  attr_accessor :title, :img_src, :img_alt, :price, :link, :year, :engine_size, :engine_type, :mileage, :posted,
                :county, :rank
end
