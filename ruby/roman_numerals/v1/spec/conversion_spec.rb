require 'conversion'

RSpec.describe Conversion do

    CHART = {
    1    => 'I',
    5    => 'V',
    10   => 'X',
    100  => 'C',
    400  => 'CD',
    900  => 'CM',
    1000 => 'M'
  }

  TRANSLATIONS = {
    'IIIIIIIII' => 'IX',
    'IIIIII'    => 'VI',
    'IIII'      => 'IV',
    'XXXXXXXXX' => 'XC',
    'XXXXXX'    => 'LX',
    'XXXXX'     => 'L',
    'XXXX'      => 'XL',
    'CCCCC'     => 'D',
    'DD'        => 'M'
  }

  subject { Conversion.new(CHART, TRANSLATIONS) }

  describe 'methods' do
    it '#from' do
      expect('a').to eq(subject.from('a').value)
    end

    it '#to' do
      expect(subject.from('a').to('b')).to eq(true)
    end

    it 'Finally, #render pulls everything together.' do
      expect( single_subject.render ).to eq( 'boom' )
    end

     it 'First, it breaks @value into #fragments.' do
      expect( subject.fragments ).to eq(
        {
          :single => 9,
          :duo => 60,
          :trio => 500,
          :quad => 2000
        })
    end
  end
end
