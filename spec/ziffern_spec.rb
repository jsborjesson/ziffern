require_relative '../lib/ziffern'

describe Ziffern do

  context "conversions" do

    def self.test_conversions(method_name = :to_text, hash)
      hash.each do |input, output|
        instance_eval do
          it "converts #{input} to #{output}" do
            expect(Ziffern.public_send(method_name, input)).to eq output
          end
        end
      end
    end

    context 'numbers up to 20' do
      test_conversions({
        0  => "null",
        1  => "eins",
        13 => "dreizehn",
        19 => "neunzehn",
      })
    end

    context 'numbers up to 100' do
      test_conversions({
        20 => "zwanzig",
        21 => "einundzwanzig",
        63 => "dreiundsechzig",
        99 => "neunundneunzig",
      })
    end

    context 'numbers up to 1000' do
      test_conversions({
        100 => "einhundert",
        234 => "zweihundertvierunddreißig",
        999 => "neunhundertneunundneunzig",
      })
    end

    context 'numbers up to one million' do
      test_conversions({
        1000    => "eintausend",
        1234    => "eintausendzweihundertvierunddreißig",
        10_000  => "zehntausend",
        999_999 => "neunhundertneunundneunzigtausendneunhundertneunundneunzig",
      })
    end

    context 'really big numbers' do
      test_conversions({
        1_000_000     => "eine Million",
        1_000_001     => "eine Million eins",
        2_204_510     => "zwei Millionen zweihundertviertausendfünfhundertzehn",
        1_203_400_021 => "eine Milliarde zweihundertdrei Millionen vierhunderttausendeinundzwanzig",
        3_000_000_000_000_099 => "drei Billiarden neunundneunzig",
        10 ** 123 => "eine Vigintilliarde"
      })
    end

    context 'negative numbers' do
      test_conversions({
        -1  => "minus eins",
        -20 => "minus zwanzig",
        -21 => "minus einundzwanzig",
        -63 => "minus dreiundsechzig",
        -99 => "minus neunundneunzig",
      })
    end

    context 'decimals' do
      test_conversions({
        0.1234  => "null Komma eins zwei drei vier",
        5.6789  => "fünf Komma sechs sieben acht neun",
        5.0     => "fünf Komma null",
        -5.6    => "minus fünf Komma sechs",
        -567.89 => "minus fünfhundertsiebenundsechzig Komma acht neun",
        -0.001  => "minus null Komma null null eins"
      })
    end

    context 'strings' do
      test_conversions({
        '-0'     => "null",
        '-123'   => "minus einhundertdreiundzwanzig",
        '-123.1' => "minus einhundertdreiundzwanzig Komma eins",
        '5.00'   => "fünf Komma null null",
      })
    end

    context 'currency' do
      test_conversions(:to_euro, {
        5     => "fünf Euro",
        5.0   => "fünf Euro",
        5.5   => "fünf Euro und fünfzig Cent",
        5.55  => "fünf Euro und fünfundfünfzig Cent",
        5.555 => "fünf Euro und sechsundfünfzig Cent",
      })
    end

  end

  context 'errors' do
    it 'raises an error if the number is bigger than it can handle' do
      expect { Ziffern.to_text(10 ** 126)  }.to raise_error Ziffern::TooLargeNumberError
      expect { Ziffern.to_text(-10 ** 126) }.to raise_error Ziffern::TooLargeNumberError
    end

    it 'raises an error on faulty input' do
      expect { Ziffern.to_text("invalid")   }.to raise_error Ziffern::InvalidNumberError
      expect { Ziffern.to_text("invalid.5") }.to raise_error Ziffern::InvalidNumberError
      expect { Ziffern.to_text("5.5u")      }.to raise_error Ziffern::InvalidNumberError
    end
  end

  context "interface" do

    it "has #to_f and #to_i on all classes" do
      [
        Ziffern::GermanInteger,
        Ziffern::GermanBigInteger,
        Ziffern::GermanFloat,
        Ziffern::GermanCurrency
      ].each do |klass|
        number = klass.new('44.5')
        expect(number.to_i).to eq 44
        expect(number.to_f).to eq 44.5
      end
    end

  end

  # these are only used for TDD or to bump the test coverage to 100% - they are safe to delete
  context 'implementation details (delete them if they fail alone)' do

    it "raises TooLargeNumber if GermanInteger gets a number over a million" do
      expect { Ziffern::GermanInteger.new(1000_000).to_s }.to raise_error Ziffern::TooLargeNumberError
    end

  end

end
