require_relative "./german_float"

module Ziffern
  class GermanCurrencyFloat < GermanFloat

    def initialize(number, currency = 'Euro', cent = 'Cent')
      super(number)
      @currency, @cent = currency, cent
    end

    def to_s
      result = [integer, currency]

      if has_cents?
        result << 'und' << decimals << cent
      end

      result.join(' ')
    end

    private

    attr_reader :currency, :cent

    def has_cents?
      number % 1 != 0
    end

    def decimals
      integer_klass.new(double_digit_rounded_decimals).to_s
    end

    def double_digit_rounded_decimals
      get_decimals_as_string.ljust(3, '0')[0..2].to_i.round(-1) / 10
    end

  end
end
