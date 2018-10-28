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

  def to(unit='')
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
  end
end
