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
    convert_integer_with_sign(number) + convert_decimals(number)
  end

  private

  def convert_integer_with_sign(number)
    number = number.to_i
    text = convert_integer(number.abs)
    text = "minus #{text}" if number < 0
    text
  end

  def convert_integer(number)
    convert(number.to_i, 'eins')
  end

  def convert(number, one='ein')
    case number
    when 1             then one
    when 0..19         then NINETEEN[number]
    when 20..99        then twenty_to_99(number)
    when 100..999      then quantify_by_factor(100,  'hundert', number)
    when 1000..999_999 then quantify_by_factor(1000, 'tausend', number)
    else bignums(number)
    end
  end

  def twenty_to_99(number)
    ten, remainder = number.divmod(10)

    if remainder.zero?
      TENS[ten]
    else
      "#{NINETEEN[remainder]}und#{TENS[ten]}"
    end
  end

  def quantify_by_factor(factor, name, number)
    amount, remainder = number.divmod(factor)

    result = convert(amount) + name
    result.tap do |result|
      result << convert(remainder) unless remainder.zero?
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
    quantity = convert(amount, 'eine')
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

  def convert_decimals(number)
    decimals = get_decimals_as_string(number)
    return '' if decimals.empty?

    ' Komma ' + convert_digits(decimals)
  end

  def get_decimals_as_string(number)
    number.to_s[/\.(\d+)/, 1].to_s
  end

  def convert_digits(number)
    number.to_s.chars.map { |digit| convert_integer(digit) }.join(' ')
  end
end
