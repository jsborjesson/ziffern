require_relative "ziffern/german_float"

module Ziffern
  extend self

  TooLargeNumberError = Class.new(ArgumentError)
  InvalidNumberError  = Class.new(ArgumentError)

  def to_text(number)
    GermanFloat.new(number).to_s
  end

end
