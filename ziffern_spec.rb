require './ziffern'

describe Ziffern do

  subject { Ziffern.new }

  it 'converts numbers under 20' do
    expect(subject.to_german(0)).to eq "null"
    expect(subject.to_german(1)).to eq "eins"
    expect(subject.to_german(13)).to eq "dreizehn"
    expect(subject.to_german(19)).to eq "neunzehn"
  end

  it 'converts numbers between 20 and 100' do
    expect(subject.to_german(20)).to eq "zwanzig"
    expect(subject.to_german(63)).to eq "dreiundsechzig"
    expect(subject.to_german(99)).to eq "neunundneunzig"
  end

  it 'converts numbers between 100 and 1000' do
    expect(subject.to_german(100)).to eq "einhundert"
    expect(subject.to_german(234)).to eq "zweihundertvierunddreißig"
    expect(subject.to_german(999)).to eq "neunhundertneunundneunzig"
  end

end
