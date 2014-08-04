class Ziffern

  NINETEEN = %w{ null eins zwei drei vier fünf sechs sieben acht neun zehn elf zwölf
                 dreizehn vierzehn fünfzehn sechzehn siebzehn achtzehn neunzehn }

  TENS = %w{ zwanzig dreißig vierzig fünfzig sechzig siebzig achtzig neunzig }.unshift(nil, nil)

  def to_german(number)
    if number < 20
      NINETEEN[number]
    elsif number < 100
      tens(number)
    elsif number < 1000
      hundreds(number)
    end
  end

  private
  def tens(number)
    ten, remainder = number.divmod(10)

    # without dup this changes the array and causes very weird bugs
    TENS[ten].dup.tap do |str|
      str.prepend("#{to_german(remainder)}und") unless remainder.zero?
    end
  end

  def hundreds(number)
    hundred, remainder = number.divmod(100)

    "hundert".tap do |str|
      str.prepend 'ein' if hundred == 1 # edge case
      str.prepend NINETEEN[hundred] if hundred >= 2

      str << to_german(remainder) unless remainder.zero?
    end
  end
end

