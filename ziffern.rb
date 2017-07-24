class Ziffern
  # http://de.wikipedia.org/wiki/Zahlennamen

  FIRST_TWENTY = %w[
    null
    WRONG_INDEX
    zwei
    drei
    vier
    fünf
    sechs
    sieben
    acht
    neun
    zehn
    elf
    zwölf
    dreizehn
    vierzehn
    fünfzehn
    sechzehn
    siebzehn
    achtzehn
    neunzehn
  ].freeze

  TENS = %w[
    WRONG_INDEX
    WRONG_INDEX
    zwanzig
    dreißig
    vierzig
    fünfzig
    sechzig
    siebzig
    achtzig
    neunzig
  ].freeze

  LARGE_NUMBERS = %w[
    M
    B
    Tr
    Quadr
    Quint
    Sext
    Sept
    Okt
    Non
    Dez
    Undez
    Dodez
    Tredez
    Quattuordez
    Quindez
    Sedez
    Septendez
    Dodevigint
    Undevigint
    Vigint
  ].flat_map { |prefix|
    %W[#{prefix}illion #{prefix}illiarde]
  }.freeze

  TooLargeNumberError = Class.new(ArgumentError)
  InvalidNumberError  = Class.new(ArgumentError)

  def to_german(number)
    fail InvalidNumberError unless valid_number?(number)
    result = convert_sign(number) + convert_integer(number) + convert_decimals(number)
    result << "s" if number.to_s.end_with?("01") && !result.end_with?("s")
    result
  end

  private

  def valid_number?(number)
    !number.to_s.match(/\A-?\d+(\.\d+)?\z/).nil?
  end

  def convert_sign(number)
    number.to_f < 0 ? "minus " : ""
  end

  def convert_integer(number)
    convert(number.to_i.abs, "eins")
  end

  def convert(number, one = "ein")
    case number
    when 1             then one
    when 0..19         then FIRST_TWENTY[number]
    when 20..99        then twenty_to_99(number)
    when 100..999      then quantify_by_factor(100,  "hundert", number)
    when 1000..999_999 then quantify_by_factor(1000, "tausend", number)
    else convert_large_number(number)
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

  def convert_large_number(number)
    number_of_millions, remainder = number.divmod(1_000_000)

    text = convert_millions(number_of_millions)
    text << " " << convert_integer(remainder) unless remainder.zero?

    text
  end

  def convert_millions(number_of_millions)
    named_number_groups = slice_by_factor(number_of_millions, 1000)
    large_number_names  = large_number_names(named_number_groups.count)

    fail TooLargeNumberError if named_number_groups.size > LARGE_NUMBERS.size

    named_number_groups
      .zip(large_number_names)
      .reject { |amount, _| amount.zero? }
      .map    { |amount, name| quantify_big_name(amount, name) }
      .join(" ")
  end

  def quantify_big_name(amount, big_name)
    [convert(amount, "eine"), pluralize_big_name(amount, big_name)].join(" ")
  end

  def pluralize_big_name(amount, big_name)
    amount == 1 ? big_name : big_name.sub(/(e?)$/, "en")
  end

  # slice_by_factor(12345678, 1000) => [12, 345, 678]
  def slice_by_factor(number, factor)
    result    = []
    remainder = number

    until remainder.zero?
      remainder, slice = remainder.divmod(factor)
      result << slice
    end

    result.reverse
  end

  # large_number_names(3) => ["Billion", "Milliarde", "Million"]
  def large_number_names(count)
    LARGE_NUMBERS.take(count).reverse
  end

  def convert_decimals(number)
    decimals = get_decimals_as_string(number)
    return "" if decimals.empty?

    " Komma " + convert_digits(decimals)
  end

  def get_decimals_as_string(number)
    number.to_s[/\.(\d+)/, 1].to_s
  end

  def convert_digits(number)
    number.to_s.chars.map { |digit| convert_integer(digit) }.join(" ")
  end
end
