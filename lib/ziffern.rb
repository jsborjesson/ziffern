require_relative "ziffern/german_float"
require_relative "ziffern/german_currency_float"

module Ziffern
  extend self

  TooLargeNumberError = Class.new(ArgumentError)
  InvalidNumberError  = Class.new(ArgumentError)

  def to_text(number)
    GermanFloat.new(number).to_s
  end

  def to_euro(amount)
    GermanCurrencyFloat.new(amount).to_s
  end

end
