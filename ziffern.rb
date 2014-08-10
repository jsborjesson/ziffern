class Ziffern

  # http://de.wikipedia.org/wiki/Zahlennamen

  NINETEEN = %w{ null ein zwei drei vier fünf sechs sieben acht neun zehn elf zwölf
                 dreizehn vierzehn fünfzehn sechzehn siebzehn achtzehn neunzehn }

  TENS = %w{ zwanzig dreißig vierzig fünfzig sechzig siebzig achtzig neunzig }.unshift(nil, nil)

  BIG = %w{ M B Tr Quadr Quint Sext Sept Okt Non Dez Undez Dodez Tredez
            Quattuordez Quindez Sedez Septendez Dodevigint Undevigint Vigint }.flat_map do |prefix|
    %W( #{prefix}illion #{prefix}illiarde )
  end


  def to_german(number)
    convert_integer(number) + convert_decimals(number)
  end

  private

  def convert_integer(number)
    number = number.to_i
    return 'eins' if number == 1
    return "minus #{convert_integer(number.abs)}" if number < 0
    convert(number)
  end

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
    return '' unless has_decimals?(number)
    decimals = get_decimals_as_string(number)

    ' Komma ' + convert_digits(decimals)
  end

  def has_decimals?(number)
    number.to_f % 1 != 0
  end

  def get_decimals_as_string(number)
    number.to_s[/\.(\d+)/, 1].to_s
  end

  def convert_digits(number)
    number.to_s.chars.map { |digit| convert_integer(digit) }.join(' ')
  end

  def twenty_to_99(number)
    ten, remainder = number.divmod(10)

    if remainder.zero?
      TENS[ten]
    else
      "#{NINETEEN[remainder]}und#{TENS[ten]}"
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
      result << " " << convert_integer(remainder) unless remainder.zero?
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
    big_name = big_name.sub(/(e?)$/, 'en') unless amount == 1

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
