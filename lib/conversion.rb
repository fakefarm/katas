class MissingConverstionChart < StandardError; end

class Conversion

  attr_accessor :conversion_chart, :value, :base, :translations

  def initialize(conversion_chart={}, translations={})
    @conversion_chart = conversion_chart
    @translations = translations
  end

  def from(from)
    @value = from
    self
  end

  def to
    case @conversion_chart.size
    when 0 then raise MissingConverstionChart, 'Please supply conversion chart'
    else convert
    end
  end

  def convert
    elements.map do |position,number|
      base[position] = convert_element(number)
    end.join('')
  end

  def elements
    @base = {
      thousands: get_thousand,
      hundreds: get_hundred,
      tens: get_ten,
      ones: get_one
    }.delete_if { |_,number| number == 0 }
  end

  def convert_element(element)
    case
    when synthetic(element)
      translate(build(element))
    else
      conversion_chart[element]
    end
  end

  def build(number)
    key = denominator(number)
    repeat = number / denominator(number)
    repeat.times.map { conversion_chart[key] }.join('')
  end

  def register_translation(from, to)
    translations[from] = to
  end

  def translate(element)
    report = translations.map do |t|
      element.gsub!(t[0], t[1])
    end.join('')
    report.empty? ? element : report
  end

private

  def get_thousand
    value - (value % 1000)
  end

  def get_hundred
    (value - (value % 100)) - get_thousand
  end

  def get_ten
    ten = (value - get_thousand - get_hundred)
    ten - ten % 10
  end

  def get_one
    value - get_thousand - get_hundred - get_ten
  end

  def denominator(number)
    # _dw add rubocop or flay or whatever mike v uses.
    case number.to_s.length
      when 1 then 1
      when 2 then 10
      when 3 then 100
      when 4 then 1000
    end
  end

  def synthetic(number)
    conversion_chart[number].nil?
  end
end
