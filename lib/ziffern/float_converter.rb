require_relative "./integer_converter"

module Ziffern
  class FloatConverter

    def initialize(integer_converter = IntegerConverter.new)
      self.integer_converter = integer_converter
    end

    def to_text(number)
      fail InvalidNumberError unless valid_number?(number)
      integer_converter.to_text(number) + convert_decimals(number)
    end

    private

    attr_accessor :integer_converter

    def valid_number?(number)
      !!number.to_s[/\A-?\d+(\.\d+)?\z/]
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
      number.to_s.chars.map { |digit| integer_converter.to_text(digit) }.join(' ')
    end
  end
end
