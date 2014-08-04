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
      0 => "null",
      1 => "eins",
      13 => "dreizehn",
      19 => "neunzehn",
    })
  end

  context 'numbers up to 100' do
    test_german_numbers({
      20 => "zwanzig",
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

end
