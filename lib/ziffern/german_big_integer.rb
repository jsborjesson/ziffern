require_relative "./german_integer"

module Ziffern
  class GermanBigInteger < GermanInteger

    # http://de.wikipedia.org/wiki/Zahlennamen
    BIG = %w[
      M B Tr Quadr Quint Sext Sept Okt Non Dez Undez Dodez Tredez
      Quattuordez Quindez Sedez Septendez Dodevigint Undevigint Vigint
    ].flat_map { |prefix|
      %W[ #{prefix}illion #{prefix}illiarde ]
    }

    private

    # override to take care of even bigger numbers
    def convert(*args)
      number = args[0]
      if number >= 1000_000
        convert_big_number(number)
      else
        super
      end
    end

    def convert_big_number(number)
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
        .map    { |amount, name| quantify_big_name(amount, name) }
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

  end
end
