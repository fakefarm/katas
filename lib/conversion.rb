class MissingConverstionChart < StandardError; end

class Conversion

  attr_accessor :conversions, :value, :base, :translations

  def initialize(conversions={}, translations={})
    @conversions = conversions
    @translations = translations
  end

  def from(from)
    @value = from
    self
  end

  def to
    case @conversions.size
    when 0 then raise MissingConverstionChart, 'Please supply conversions'
      else render
    end
  end

  def render
    fragments.map do |position,fragment|
      base[position] = convert(fragment)
    end.join('')
  end

  def fragments
    @base = {
      quad: get_quad,
      trio: get_trio,
      duo: get_duo,
      single: get_single
    }.delete_if { |_,number| number == 0 }
  end

  def convert(fragment)
    case
    when synthetic(fragment)
      translate(breed(fragment))
    else
      conversions[fragment]
    end
  end

  def breed(number)
    key = conversion_key(number)
    sex = number / key
    sex.times.map { conversions[key] }.join('')
  end

  def register_translation(from, to)
    translations[from] = to
  end

  def register_conversion(from, to)
    conversions[from] = to
  end

  def translate(element)
    report = translations.map do |t|
      element.gsub!(t[0].to_s, t[1].to_s)
    end.join('')
    report.empty? ? element : report
  end

private

  def get_quad
    value - (value % 1000)
  end

  def get_trio
    (value - (value % 100)) - get_quad
  end

  def get_duo
    ten = (value - get_quad - get_trio)
    ten - ten % 10
  end

  def get_single
    value - get_quad - get_trio - get_duo
  end

  def conversion_key(number)
    # _dw add rubocop or flay or whatever mike v uses.
    case number.to_s.length
      when 1 then 1
      when 2 then 10
      when 3 then 100
      when 4 then 1000
    end
  end

  def synthetic(number)
    conversions[number].nil?
  end
end
