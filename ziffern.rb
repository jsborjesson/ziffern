class Ziffern

  NINETEEN = %w{ null ein zwei drei vier fünf sechs sieben acht neun zehn elf zwölf
                 dreizehn vierzehn fünfzehn sechzehn siebzehn achtzehn neunzehn }

  TENS = %w{ zwanzig dreißig vierzig fünfzig sechzig siebzig achtzig neunzig }.unshift(nil, nil)

  # http://de.wikipedia.org/wiki/Zahlennamen
  BIG = %w{ M B Tr Quadr Quint Sext Sept Okt Non Dez }.flat_map { |prefix|
    %W( #{prefix}illion #{prefix}illiarde )
  }


  def to_german(number)
    if number == 1
      'eins' # edge case
    else
      convert(number)
    end
  end

  private

  def convert(number)
    if number < 20
      NINETEEN[number]
    elsif number < 100
      twenty_to_99(number)
    elsif number < 1000
      reduce_by_factor(100, 'hundert', number)
    elsif number < 1000_000
      reduce_by_factor(1000, 'tausend', number)
    else
      bignums(number)
    end
  end

  def twenty_to_99(number)
    ten, remainder = number.divmod(10)

    # without dup this changes the array and causes very weird bugs
    TENS[ten].dup.tap do |str|
      str.prepend("#{NINETEEN[remainder]}und") unless remainder.zero?
    end
  end

  def reduce_by_factor(factor, word, number)
    amount, remainder = number.divmod(factor)

    word.tap do |str|
      str.prepend convert(amount)
      str << convert(remainder) unless remainder.zero?
    end
  end

  def bignums(number)
    big, normal = number.divmod(1000_000)

    result = illions(big)
    result << " " << convert(normal) unless normal.zero?
    result
  end

  def illions(number_of_millions)
    groups = group_by_3_reverse(number_of_millions)
    fail ArgumentError, 'Number too large' if groups.size > BIG.size
    groups
      .zip(BIG)
      .reject { |amount, *| amount.zero? }
      .map { |amount, illion| quantify_illion(amount, illion) }
      .reverse
      .join(' ')
  end

  def quantify_illion(amount, illion)
    # handle ein/eine
    quantity = amount == 1 ? 'eine' : convert(amount)

    # pluralize illion
    illion   = illion.sub(/(e?)$/, 'en') unless amount == 1

    "#{quantity} #{illion}"
  end

  # 12345678 => [678, 345, 12]
  def group_by_3_reverse(number)
    [].tap do |groups|
      until number.zero?
        number, group = number.divmod(1000)
        groups << group
      end
    end
  end
end

