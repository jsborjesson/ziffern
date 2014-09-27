require_relative "./german_big_integer"

module Ziffern
  class GermanFloat < GermanBigInteger

    attr_reader :number

    def initialize(number)
      @number = number
      @comma = 'Komma'

      fail InvalidNumberError unless valid_number?
    end

    def to_s
      if has_decimals?
        [super, comma, decimals].join(' ')
      else
        super
      end
    end

    private

    attr_reader :comma

    def decimals
      convert_digits(get_decimals_as_string)
    end

    def has_decimals?
      not get_decimals_as_string.empty?
    end


    def valid_number?
      !!number.to_s[/\A-?\d+(\.\d+)?\z/]
    end

    def get_decimals_as_string
      number.to_s[/\.(\d+)/, 1].to_s
    end

    def convert_digits(digits)
      digits.to_s.chars.map { |digit| convert_integer(digit) }.join(' ')
    end
  end
end
