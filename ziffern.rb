class Ziffern

  NINETEEN = %w{ null ein zwei drei vier fünf sechs sieben acht neun zehn elf zwölf
                 dreizehn vierzehn fünfzehn sechzehn siebzehn achtzehn neunzehn }

  TENS = %w{ zwanzig dreißig vierzig fünfzig sechzig siebzig achtzig neunzig }.unshift(nil, nil)

  # http://de.wikipedia.org/wiki/Zahlennamen
  BIG = [nil, 'tausend'] + %w{ M B Tr Quadr Quint Sext Sept Okt Non Dez}.flat_map { |prefix|
    %W( #{prefix}illion #{prefix}illiarde )
  }

  def to_german(number)
    if number == 1
      'eins'
    elsif number < 20
      NINETEEN[number]
    elsif number < 100
      twenty_to_99(number)
    elsif number < 1000
      hundred_to_999(number)
    end
  end

  private
  def twenty_to_99(number)
    ten, remainder = number.divmod(10)

    # without dup this changes the array and causes very weird bugs
    TENS[ten].dup.tap do |str|
      str.prepend("#{NINETEEN[remainder]}und") unless remainder.zero?
    end
  end

  def hundred_to_999(number)
    hundred, remainder = number.divmod(100)

    "hundert".tap do |str|
      str.prepend NINETEEN[hundred]

      str << to_german(remainder) unless remainder.zero?
    end
  end
end

