class Ziffern

  NINETEEN = %w{ null eins zwei drei vier fünf sechs sieben acht neun zehn elf zwölf
                 dreizehn vierzehn fünfzehn sechzehn siebzehn achtzehn neunzehn }

  def to_german(number)
    if number < 20
      NINETEEN[number]
    end
  end
end
