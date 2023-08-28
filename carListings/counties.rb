# frozen_string_literal: true

module Counties
  COUNTY_DISTANCES = {
    'Sligo' => 0,
    'Leitrim' => 20,
    'Donegal' => 50,
    'Roscommon' => 70,
    'Mayo' => 80,
    'Cavan' => 90,
    'Longford' => 100,
    'Galway' => 100,
    'Fermanagh' => 110,
    'Westmeath' => 120,
    'Monaghan' => 130,
    'Meath' => 130,
    'Louth' => 140,
    'Clare' => 150,
    'Tipperary' => 170,
    'Kerry' => 180,
    'Limerick' => 190,
    'Kilkenny' => 200,
    'Waterford' => 210,
    'Wicklow' => 220,
    'Carlow' => 230,
    'Dublin' => 240,
    'Offaly' => 240,
    'Wexford' => 250,
    'Kildare' => 260,
    'Laois' => 270,
    'Cork' => 280
  }.freeze

  def self.distance_from_home(county)
    COUNTY_DISTANCES[county] || Float::INFINITY
  end

  def sort_counties_by_distance_from_home(counties)
    counties.sort_by { |county| distance_from_home(county) }
  end
end
