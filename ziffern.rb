class Ziffern

  NINETEEN = %w{ null ein zwei drei vier fünf sechs sieben acht neun zehn elf zwölf
                 dreizehn vierzehn fünfzehn sechzehn siebzehn achtzehn neunzehn }

  TENS = %w{ zwanzig dreißig vierzig fünfzig sechzig siebzig achtzig neunzig }.unshift(nil, nil)

  # http://de.wikipedia.org/wiki/Zahlennamen
  BIG = %w{ M B Tr Quadr Quint Sext Sept Okt Non Dez }.flat_map { |prefix|
    %W( #{prefix}illion #{prefix}illiarde )
  }


  def to_german(number)
    return 'eins' if number == 1
    return "minus #{to_german(number.abs)}" if number < 0

    convert(number.to_i) + convert_decimals(number)
  end

  private

  def convert(number)
    case number
    when 0..19         then NINETEEN[number]
    when 20..99        then twenty_to_99(number)
    when 100..999      then reduce_by_factor(100,  'hundert', number)
    when 1000..999_999 then reduce_by_factor(1000, 'tausend', number)
    else bignums(number)
    end
  end

  def convert_decimals(number)
     # get decimals, floating point math sucks so string is easier
    decimals = number.to_s[/.+\.(\d+)/, 1]
    return '' if decimals.nil?
    decimals
      .chars.map(&:to_i)     # array of ints
      .map { |digit| to_german(digit) }
      .join(' ')
      .prepend(' Komma ')
  end

  def twenty_to_99(number)
    ten, remainder = number.divmod(10)

    # without dup this changes the array and causes very weird bugs
    TENS[ten].dup.tap do |str|
      str.prepend("#{NINETEEN[remainder]}und") unless remainder.zero?
    end
  end

  def reduce_by_factor(factor, word, number)
    amount, remainder = number.divmod(factor)

    word.tap do |str|
      str.prepend(convert(amount))
      str << convert(remainder) unless remainder.zero?
    end
  end

  def bignums(number)
    number_of_millions, remainder = number.divmod(1000_000)

    convert_millions(number_of_millions).tap do |result|
      result << " " << convert(remainder) unless remainder.zero?
    end
  end

  def convert_millions(number_of_millions)
    groups = group_with_big_names(number_of_millions)
    fail ArgumentError, 'Number too large' if groups.size > BIG.size
    groups
      .reject { |amount, *| amount.zero? }
      .map { |amount, name| quantify_big_name(amount, name) }
      .join(' ')
  end

  def quantify_big_name(amount, big_name)
    # handle ein/eine
    quantity = amount == 1 ? 'eine' : convert(amount)

    # pluralize big_name
    big_name   = big_name.sub(/(e?)$/, 'en') unless amount == 1

    "#{quantity} #{big_name}"
  end

  # 12345678 => [[12, "Billion"], [345, "Milliarde"], [678, "Million"]]
  def group_with_big_names(number_of_millions)
    groups = []

    until number_of_millions.zero?
      number_of_millions, last_3 = number_of_millions.divmod(1000)
      groups << last_3
    end

    groups.zip(BIG).reverse
  end
end
