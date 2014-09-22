require_relative "./big_integer_converter"

module Ziffern
  class FloatConverter

    def initialize
      @integer_converter = BigIntegerConverter.new
      @comma = 'Komma'
    end

    def to_text(number)
      fail InvalidNumberError unless valid_number?(number)
      convert_float(number)
    end

    private

    attr_reader :integer_converter, :comma

    def valid_number?(number)
      !!number.to_s[/\A-?\d+(\.\d+)?\z/]
    end

    def convert_float(number)
      decimals = get_decimals_as_string(number)
      result   = []

      result << integer_converter.to_text(number)

      unless decimals.empty?
        result << comma
        result << convert_digits(decimals)
      end

      result.join(' ')
    end

    def get_decimals_as_string(number)
      number.to_s[/\.(\d+)/, 1].to_s
    end

    def convert_digits(number)
      number.to_s.chars.map { |digit| integer_converter.to_text(digit) }.join(' ')
    end
  end
end
