require 'roman_numerals'
require_relative 'fixtures/conversion_chart.rb'

RSpec.describe RomanNumerals do
  CONVERSION_TEST.each do |arabic, roman|
    it "#{arabic} to #{roman}" do
      expect(RomanNumerals.new(arabic).roman_numeral).to eq(roman)
    end
  end

  it 'has ones' do
    expect( RomanNumerals.new(9).ones ).to eq(9)
  end

  it 'has tens' do
    expect( RomanNumerals.new(11).tens ).to eq(10)
  end

  it 'has hundreds' do
    expect( RomanNumerals.new(110).hundreds ).to eq(100)
  end

  it 'has thousands' do
    expect( RomanNumerals.new(1100).thousands ).to eq(1000)
  end

  it 'splits numbers into digits' do
    expect( RomanNumerals.new(1111).split ).to eq([1000, 100, 10, 1])
  end

  it 'converts' do
    expect( RomanNumerals.new(1111).convert ).to eq(['M', 'C', 'X', 'I'])
  end

  it 'merge' do
    expect( RomanNumerals.new(1111).merge ).to eq('MCXI')
  end

  it 'investigates' do
    expect( RomanNumerals.new(2).investigate ).to eq(['II'])
    expect( RomanNumerals.new(21).investigate ).to eq(['XX','I'])
    expect( RomanNumerals.new(321).investigate ).to eq(['CCC','XX','I'])
  end

  it 'synthetic_numbers' do
    expect( RomanNumerals.new(2).synthetic_numbers ).to eq({:ones => 2})
    expect( RomanNumerals.new.convert_ones(3) ).to eq("III")
  end

  it 'convert_ones' do
    expect( RomanNumerals.new.convert_ones(1) ).to eq("I")
    expect( RomanNumerals.new.convert_ones(2) ).to eq("II")
    expect( RomanNumerals.new.convert_ones(3) ).to eq("III")
    expect( RomanNumerals.new.convert_ones(5) ).to eq("V")
    expect( RomanNumerals.new.convert_ones(6) ).to eq("VI")
    expect( RomanNumerals.new.convert_ones(7) ).to eq("VII")
    expect( RomanNumerals.new.convert_ones(8) ).to eq("VIII")
  end

  it 'convert_tens' do
    expect( RomanNumerals.new.convert_tens(20) ).to eq("XX")
    expect( RomanNumerals.new.convert_tens(30) ).to eq("XXX")
    expect( RomanNumerals.new.convert_tens(50) ).to eq("L")
    expect( RomanNumerals.new.convert_tens(70) ).to eq("LXX")
    expect( RomanNumerals.new.convert_tens(80) ).to eq("LXXX")
  end

  it 'convert_hundreds' do
    expect( RomanNumerals.new.convert_hundreds(200) ).to eq("CC")
    expect( RomanNumerals.new.convert_hundreds(300) ).to eq("CCC")
    expect( RomanNumerals.new.convert_hundreds(500) ).to eq("D")
    expect( RomanNumerals.new.convert_hundreds(700) ).to eq("DCC")
    expect( RomanNumerals.new.convert_hundreds(800) ).to eq("DCCC")
  end

  it 'convert_thousands' do
    expect( RomanNumerals.new.convert_thousands(2000) ).to eq("MM")
    expect( RomanNumerals.new.convert_thousands(3000) ).to eq("MMM")
  end
end
