class Ziffern

  NINETEEN = %w{ null eins zwei drei vier fünf sechs sieben acht neun zehn elf zwölf
                 dreizehn vierzehn fünfzehn sechzehn siebzehn achtzehn neunzehn }

  TENS = %w{ zwanzig dreißig vierzig fünfzig sechzig siebzig achtzig neunzig }.unshift(nil, nil)

  def to_german(number)
    if number < 20
      NINETEEN[number]
    elsif number < 100
      ten, single = number.divmod(10)

      TENS[ten].tap do |str|
        str.prepend("#{NINETEEN[single]}und") unless single.zero?
      end
    end
  end
end
