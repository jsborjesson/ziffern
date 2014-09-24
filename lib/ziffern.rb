require_relative "ziffern/german_float"
require_relative "ziffern/german_currency"

module Ziffern
  extend self

  TooLargeNumberError = Class.new(ArgumentError)
  InvalidNumberError  = Class.new(ArgumentError)

  def to_text(number)
    GermanFloat.new(number).to_s
  end

  def to_euro(amount)
    GermanCurrency.new(amount, 'Euro').to_s
  end

end
