require 'roman_numeral'
require_relative 'fixtures/arabic_roman.rb'

RSpec.describe RomanNumeral do

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

  subject { RomanNumeral.new(CHART, TRANSLATIONS) }

  let (:single_fixture) { { from: 7, to: 'VII' } }
  let (:single_subject) { subject.from(single_fixture[:from]) }

  let (:double_fixture) { { from: 42, to: 'XLII' } }
  let (:double_subject) { subject.from(double_fixture[:from]) }

  let (:triple_fixture) { { from: 156, to: 'CLVI' } }
  let (:triple_subject) { subject.from(triple_fixture[:from]) }

  let (:quad_fixture) { { from: 2569, to: 'MMDLXIX' } }
  let (:quad_subject) { subject.from(quad_fixture[:from]) }

  ARABIC_ROMAN.each do |from, to|
    it "#{from} to #{to}" do
      expect(subject.from(from).to).to eq(to)
    end
  end

  describe 'requires a @conversions chart.' do
    it 'Which can be provided on #new.' do
      expect(subject.conversions.length).to eq(CHART.length)
    end

    it 'Or, #register_conversion during run time.' do
      subject.register_conversion(10000, 'Z')
      expect(subject.convert(10000)).to eq('Z')
    end

    it 'When missing, MissingConverstionChart is raised.' do
      expect { RomanNumeral.new.to }.to raise_error('Please supply conversions')
    end
  end

  describe 'is a multi-step process.' do
    it 'First, it breaks @value into #fragments.' do
      expect( quad_subject.fragments ).to eq(
        {
          :single => 9,
          :duo => 60,
          :trio => 500,
          :quad => 2000
        })
    end

    it 'Then, it will #convert each fragement based on @conversions.' do
      expect( subject.convert(30)).to eq('XXX')
      expect( subject.convert(400)).to eq('CD')
      expect( subject.convert(500)).to eq('D')
    end

    it 'Finally, #render pulls everything together.' do
      expect( single_subject.render ).to eq( single_fixture[:to] )
      expect( double_subject.render ).to eq( double_fixture[:to] )
      expect( triple_subject.render ).to eq( triple_fixture[:to] )
      expect( quad_subject.render ).to eq( quad_fixture[:to] )
    end

    context 'During #convert, if a fragment is #synthetic,' do
      it 'The fragment will #breed.' do
        expect(subject.breed(3)).to eq('III')
        expect(subject.breed(8)).to eq('IIIIIIII')
        expect(subject.breed(30)).to eq('XXX')
        expect(subject.breed(80)).to eq('XXXXXXXX')
        expect(subject.breed(300)).to eq('CCC')
        expect(subject.breed(800)).to eq('CCCCCCCC')
      end

      it 'Then, the fragment will #translate.' do
        expect(subject.translate('IIII')).to eq('IV')
        expect(subject.translate('IIIIIII')).to eq('VII')
        expect(subject.translate('XXXXX')).to eq('L')
        expect(subject.translate('IIIIIIII')).to eq('VIII')
      end
    end
  end

  describe 'Sometimes @conversions require @translations.' do

    it 'Which can be provided on #new.' do
      expect(subject.translations.length).to eq(TRANSLATIONS.length)
    end

    it 'Or, #register_translation at run time.' do
      subject.register_translation('XYXYXY', 42)
      chromosome = 'XYXYXY'
      expect(subject.translate(chromosome)).to eq('42')
    end
  end
end
