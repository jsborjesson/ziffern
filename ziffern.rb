class Ziffern

  # http://de.wikipedia.org/wiki/Zahlennamen

  NINETEEN = %w[ null eins zwei drei vier fünf sechs sieben acht neun zehn elf zwölf
                 dreizehn vierzehn fünfzehn sechzehn siebzehn achtzehn neunzehn ]

  TENS = [nil, nil] + %w[ zwanzig dreißig vierzig fünfzig sechzig siebzig achtzig neunzig ]

  BIG = %w[
    M B Tr Quadr Quint Sext Sept Okt Non Dez Undez Dodez Tredez
    Quattuordez Quindez Sedez Septendez Dodevigint Undevigint Vigint
 ].flat_map do |prefix|
    %W[ #{prefix}illion #{prefix}illiarde ]
  end

  TooLargeNumberError = Class.new(ArgumentError)
  InvalidNumberError  = Class.new(ArgumentError)

  def to_german(number)
    fail InvalidNumberError unless valid_number?(number)
    convert_sign(number) + convert_integer(number) + convert_decimals(number)
  end

  private

  def valid_number?(number)
    !!number.to_s[/\A-?\d+(\.\d+)?\z/]
  end

  def convert_sign(number)
    if number.to_f < 0
      "minus "
    else
      ""
    end
  end

  def convert_integer(number)
    convert(number.to_i.abs, 'eins')
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
      "#{convert(remainder)}und#{TENS[ten]}"
    end
  end

  def quantify_by_factor(factor, quantifier, number)
    amount, remainder = number.divmod(factor)

    text = convert(amount) + quantifier
    text << convert(remainder) unless remainder.zero?

    text
  end

  def bignums(number)
    number_of_millions, remainder = number.divmod(1000_000)

    text = convert_millions(number_of_millions)
    text << " " << convert_integer(remainder) unless remainder.zero?

    text
  end

  def convert_millions(number_of_millions)
    pairs = pair_with_big_names(number_of_millions)
    fail TooLargeNumberError if pairs.size > BIG.size

    pairs
      .reject { |amount,| amount.zero? }
      .map { |amount, name| quantify_big_name(amount, name) }
      .join(' ')
  end

  def quantify_big_name(amount, big_name)
    quantity = convert(amount, 'eine')
    big_name = big_name.sub(/(e?)$/, 'en') unless amount == 1

    "#{quantity} #{big_name}"
  end

  # 12345678 => [[12, "Billion"], [345, "Milliarde"], [678, "Million"]]
  def pair_with_big_names(number_of_millions)
    number_groups = []

    until number_of_millions.zero?
      number_of_millions, last_3 = number_of_millions.divmod(1000)
      number_groups << last_3
    end

    number_groups.zip(BIG).reverse
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
