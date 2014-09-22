module Ziffern
  class GermanInteger

    NINETEEN = %w[ null eins zwei drei vier fünf sechs sieben acht neun zehn elf zwölf
                   dreizehn vierzehn fünfzehn sechzehn siebzehn achtzehn neunzehn ]

    TENS = [nil, nil] + %w[ zwanzig dreißig vierzig fünfzig sechzig siebzig achtzig neunzig ]

    attr_reader :number

    def initialize(number)
      @number = number
    end

    def to_s
      convert_integer(number)
    end

    def to_i
      number
    end

    private

    def convert_integer(number)
      convert_sign + convert(number.to_i.abs, 'eins')
    end

    def convert_sign
      if number.to_f < 0
        "minus "
      else
        ""
      end
    end

    def convert(number, one='ein')
      case number
      when 1             then one
      when 0..19         then NINETEEN[number]
      when 20..99        then twenty_to_99(number)
      when 100..999      then quantify_by_factor(100,  'hundert', number)
      when 1000..999_999 then quantify_by_factor(1000, 'tausend', number)
      else fail TooLargeNumberError
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

  end
end
