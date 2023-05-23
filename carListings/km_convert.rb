# frozen_string_literal: true

def km_convert(mileage)
  miles = mileage.scan(/\d+/).join('').to_f
  kilometers = miles * 1.60934
  "#{kilometers.to_i} km"
end
