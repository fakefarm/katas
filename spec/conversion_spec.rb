require 'conversion'
require_relative 'fixtures/arabic_roman.rb'

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

  ARABIC_ROMAN.each do |arabic, roman|
    it "#{arabic} to #{roman}" do
      expect(subject.from(arabic).to).to eq(roman)
    end
  end

  it 'has a value' do
    expect(subject.from(2).value).to eq(2)
  end

  it 'Requires a conversion chart' do
    expect(subject.conversion_chart.length).to eq(CHART.length)
  end

  it 'to raises MissingConverstionChart for missing chart ' do
    expect { Conversion.new.to }.to raise_error('Please supply conversion chart')
  end

  it 'convert' do
    expect( subject.from(1569).convert ).to eq( 'MDLXIX')
    expect( subject.from(1111).convert ).to eq( 'MCXI')
    expect( subject.from(2).convert ).to eq( 'II')
    expect( subject.from(21).convert ).to eq('XXI')
    expect( subject.from(321).convert ).to eq('CCCXXI')
  end

  it 'elements' do
    expect( subject.from(1569).elements ).to eq(
      {
        :ones=>9,
        :tens=>60,
        :hundreds=>500,
        :thousands=>1000
      })
  end

  it 'convert_element' do
    expect( subject.convert_element(2) ).to eq("II")
    expect( subject.convert_element(20) ).to eq("XX")
    expect( subject.convert_element(7) ).to eq("VII")
    expect( subject.convert_element(200) ).to eq("CC")
    expect( subject.convert_element(300) ).to eq("CCC")
    expect( subject.convert_element(2000) ).to eq("MM")
    expect( subject.convert_element(3000) ).to eq("MMM")
    expect( subject.convert_element(70) ).to eq("LXX")
  end

  it 'translate' do
    expect(subject.translate('II')).to eq('II')
    expect(subject.translate('IIIIIII')).to eq('VII')
    expect(subject.translate('XXXXX')).to eq('L')
    expect(subject.translate('IIIIIIII')).to eq('VIII')
  end

  it 'register_translation' do
    subject.register_translation('XYXYXY', 'Z')
    group = 'XYXYXY'
    expect(subject.translate(group)).to eq('Z')
  end

  it 'build' do
    expect(subject.build(2)).to eq('II')
  end
end
