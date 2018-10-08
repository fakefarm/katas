class RomanNumerals
  # _dw get rid of chart
  CHART = {
    1  => 'I',
    4  => 'IV',
    6  => 'VI',
    9  => 'IX',
    10 => 'X',
    40 => 'XL',
    60 => 'LX',
    90 => 'XC',
    100 => 'C',
    400 => 'CD',
    500 => 'D',
    900 => 'CM',
    1000 => 'M'
  }

  def initialize(number=0)
    @number = number
  end

  def ones
    # _dw memoize these @ones
    @number - (@number % 1)
  end

  def tens
    @number - (@number % 10)
  end

  def hundreds
    @number - (@number % 100)
  end

  def thousands
    @number - (@number % 1000)
  end

  def split # _dw rename
    [
      thousands,
      hundreds - thousands,
      tens - hundreds,
      ones - tens
    ].reject { |num| num == 0 }
  end

  def convert # _dw rename
    split.map do |n|
      CHART[n]
    end
  end

  def merge
    number = investigate
    number.join('')
  end

  def synthetic_numbers
    {
      thousands: thousands,
      hundreds: hundreds - thousands,
      tens: tens - hundreds,
      ones: ones - tens
    }.delete_if { |k,v| v == 0 }
  end

  def investigate
    conv = convert
    if conv.include?(nil)
      data = synthetic_numbers
      data.map do |k,v|
        case k
        when :ones then data[k] = convert_ones(v)
        when :tens then data[k] = convert_tens(v)
        when :hundreds then data[k] = convert_hundreds(v)
        when :thousands then data[k] = convert_thousands(v)
        end
      end
      data.values
    else
      conv
    end
  end

  def convert_ones(number) # _dw merge these methods into one
    if CHART[number].nil?
      ones = number.times.map do |i|
        'I'
      end.join('')
      ones.gsub('IIIII', 'V')
    else
      CHART[number]
    end
  end

  def convert_tens(number)
    if CHART[number].nil?
      number = number / 10
      tens = number.times.map do |i|
        'X'
      end.join('')
      tens.gsub('XXXXX', 'L')
    else
      CHART[number]
    end
  end

  def convert_hundreds(number)
    if CHART[number].nil?
      number = number / 100
      hundreds = number.times.map do |i|
        'C'
      end.join('')
      hundreds.gsub('CCCCC', 'D')
    else
      CHART[number]
    end
  end

  def convert_thousands(number)
    if CHART[number].nil?
      number = number / 1000
      thousands = number.times.map do |i|
        'M'
      end.join('')
    else
      CHART[number]
    end
  end

  def roman_numeral
    merge
  end
end
