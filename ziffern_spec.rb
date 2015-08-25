require './ziffern'

describe Ziffern do

  subject { Ziffern.new }

  def self.test_german_numbers(tests)
    tests.each do |integer, german|
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
      101 => "einhunderteins",
      234 => "zweihundertvierunddreißig",
      999 => "neunhundertneunundneunzig",
    })
  end

  context 'numbers up to one million' do
    test_german_numbers({
      1000    => "eintausend",
      1001    => "eintausendeins",
      101000  => "einhunderteintausend",
      101001  => "einhunderteintausendeins",
      1234    => "eintausendzweihundertvierunddreißig",
      10_000  => "zehntausend",
      999_999 => "neunhundertneunundneunzigtausendneunhundertneunundneunzig",
    })
  end

  context 'really big numbers' do
    test_german_numbers({
      1_000_000     => "eine Million",
      1_000_001     => "eine Million eins",
      2_204_510     => "zwei Millionen zweihundertviertausendfünfhundertzehn",
      1_203_400_021 => "eine Milliarde zweihundertdrei Millionen vierhunderttausendeinundzwanzig",
      3_000_000_000_000_099 => "drei Billiarden neunundneunzig",
      10 ** 123 => "eine Vigintilliarde"
    })
  end

  context 'negative numbers' do
    test_german_numbers({
      -1  => "minus eins",
      -20 => "minus zwanzig",
      -21 => "minus einundzwanzig",
      -63 => "minus dreiundsechzig",
      -99 => "minus neunundneunzig",
    })
  end

  context 'decimals' do
    test_german_numbers({
      0.1234  => "null Komma eins zwei drei vier",
      5.6789  => "fünf Komma sechs sieben acht neun",
      5.0     => "fünf Komma null",
      -5.6    => "minus fünf Komma sechs",
      -567.89 => "minus fünfhundertsiebenundsechzig Komma acht neun",
      -0.001  => "minus null Komma null null eins"
    })
  end

  context 'strings' do
    test_german_numbers({
      '-0'     => "null",
      '-123'   => "minus einhundertdreiundzwanzig",
      '-123.1' => "minus einhundertdreiundzwanzig Komma eins",
      '5.00'   => "fünf Komma null null",
    })
  end

  context 'errors' do
    it 'raises an error if the number is bigger than it can handle' do
      expect { subject.to_german(10 ** 126) }.to raise_error Ziffern::TooLargeNumberError
      expect { subject.to_german(-10 ** 126) }.to raise_error Ziffern::TooLargeNumberError
    end

    it 'raises an error on faulty input' do
      expect { subject.to_german("invalid") }.to raise_error Ziffern::InvalidNumberError
      expect { subject.to_german("invalid.5") }.to raise_error Ziffern::InvalidNumberError
      expect { subject.to_german("5.5u") }.to raise_error Ziffern::InvalidNumberError
    end
  end

end
