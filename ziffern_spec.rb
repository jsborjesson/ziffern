require './ziffern'

describe Ziffern do

  subject { Ziffern.new }

  def self.test_german_numbers(hash)
    hash.each do |integer, german|
      instance_eval do
        it "converts #{integer} to #{german}" do
          expect(subject.to_german(integer)).to eq german
        end
      end
    end
  end

  context 'numbers up to 20' do
    test_german_numbers({
      0  => "null",
      1  => "eins",
      13 => "dreizehn",
      19 => "neunzehn",
    })
  end

  context 'numbers up to 100' do
    test_german_numbers({
      20 => "zwanzig",
      21 => "einundzwanzig",
      63 => "dreiundsechzig",
      99 => "neunundneunzig",
    })
  end

  context 'numbers up to 1000' do
    test_german_numbers({
      100 => "einhundert",
      234 => "zweihundertvierunddreißig",
      999 => "neunhundertneunundneunzig",
    })
  end

  context 'up to one million' do
    test_german_numbers({
      1000    => "eintausend",
      1234    => "eintausendzweihundertvierunddreißig",
      10_000  => "zehntausend",
      999_999 => "neunhundertneunundneunzigtausendneunhundertneunundneunzig",
    })
  end

  context 'really big numbers' do
    test_german_numbers({
      1_000_000 => "eine Million",
      2_204_510 => "zwei Millionen zweihundertviertausendfünfhundertzehn",
      1_203_400_021 => "eine Milliarde zweihundertdrei Millionen vierhunderttausendeinundzwanzig",
      3_000_000_000_000_099 => "drei Billiarden neunundneunzig",
      10 ** 63 => "eine Dezilliarde"
    })
  end

  it 'throws an ArgumentError if the number is bigger than it can handle' do
    expect { subject.to_german(10 ** 66) }.to raise_error ArgumentError
  end

  context 'negative numbers' do
    test_german_numbers({
      -20 => "minus zwanzig",
      -21 => "minus einundzwanzig",
      -63 => "minus dreiundsechzig",
      -99 => "minus neunundneunzig",
    })
  end

end
