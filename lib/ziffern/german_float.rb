require_relative "./german_big_integer"

module Ziffern
  class GermanFloat

    attr_reader :number

    def initialize(number, integer_klass = GermanBigInteger)
      @number, @integer_klass = number, integer_klass
      @comma = 'Komma'

      fail InvalidNumberError unless valid_number?
    end

    def to_s
      if has_decimals?
        [integer, comma, decimals].join(' ')
      else
        integer
      end
    end

    def integer
      integer_klass.new(number).to_s
    end

    def decimals
      convert_digits(get_decimals_as_string)
    end

    def has_decimals?
      not get_decimals_as_string.empty?
    end

    private

    attr_reader :integer_klass, :comma

    def valid_number?
      !!number.to_s[/\A-?\d+(\.\d+)?\z/]
    end

    def get_decimals_as_string
      number.to_s[/\.(\d+)/, 1].to_s
    end

    def convert_digits(digits)
      digits.to_s.chars.map { |digit| integer_klass.new(digit) }.join(' ')
    end
  end
end
