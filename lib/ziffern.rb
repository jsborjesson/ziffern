require_relative "ziffern/float_converter"

module Ziffern
  extend self

  TooLargeNumberError = Class.new(ArgumentError)
  InvalidNumberError  = Class.new(ArgumentError)

  def to_text(number)
    FloatConverter.new.to_text(number)
  end

end
