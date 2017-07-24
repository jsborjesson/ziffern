class Ziffern
  # http://de.wikipedia.org/wiki/Zahlennamen

  AND      = "und".freeze
  MINUS    = "minus".freeze
  POINT    = "Komma".freeze
  HUNDRED  = "hundert".freeze
  THOUSAND = "tausend".freeze

  FIRST_TWENTY = %w[
    null
    ein
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

  attr_reader :number
  private :number

  def self.to_german(number)
    new(number).to_german
  end

  def initialize(number)
    @number = number
  end

  def to_german
    validate_number!

    [converted_sign, converted_integer, converted_decimals].compact.join(" ")
  end

  private

  def validate_number!
    Float(number)
  rescue ArgumentError
    raise InvalidNumberError
  end

  def converted_sign
    return MINUS if number.to_f.negative?
  end

  def converted_integer
    convert_integer(number.to_i.abs)
  end

  def converted_decimals
    return if decimals.empty?

    [POINT, converted_decimals_digits].join(" ")
  end

  def convert_integer(number)
    convert(number).sub(/(ein)$/, "eins")
  end

  def convert(number)
    case number
    when 0..19         then FIRST_TWENTY[number]
    when 20..99        then twenty_to_99(number)
    when 100..999      then quantify_by_factor(100,  HUNDRED, number)
    when 1000..999_999 then quantify_by_factor(1000, THOUSAND, number)
    else convert_large_number(number)
    end
  end

  def twenty_to_99(number)
    ten, remainder = number.divmod(10)

    if remainder.zero?
      TENS[ten]
    else
      [convert(remainder), AND, TENS[ten]].join
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
    large_number_groups = large_number_groups(number_of_millions)
    large_number_names  = large_number_names(large_number_groups.count)

    fail TooLargeNumberError if large_number_groups.size > LARGE_NUMBERS.size

    large_number_groups
      .zip(large_number_names)
      .reject { |amount, _| amount.zero? }
      .map    { |amount, name| quantify_large_number(amount, name) }
      .join(" ")
  end

  def quantify_large_number(amount, large_number_name)
    [feminine_convert(amount), pluralize_large_number(amount, large_number_name)].join(" ")
  end

  def feminine_convert(number)
    return "eine" if number == 1
    convert(number)
  end

  def pluralize_large_number(amount, large_number_name)
    return large_number_name if amount == 1
    large_number_name.sub(/(e?)$/, "en")
  end

  # large_number_groups(12345678) => [12, 345, 678]
  def large_number_groups(number_of_millions)
    result    = []
    remainder = number_of_millions

    until remainder.zero?
      remainder, large_number_group = remainder.divmod(1000)
      result << large_number_group
    end

    result.reverse
  end

  # large_number_names(3) => ["Billion", "Milliarde", "Million"]
  def large_number_names(count)
    LARGE_NUMBERS.take(count).reverse
  end

  def converted_decimals_digits
    decimals.to_s.chars.map { |digit| convert_integer(digit.to_i) }.join(" ")
  end

  def decimals
    number.to_s[/\.(\d+)/, 1].to_s
  end
end
