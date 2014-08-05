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
      'eins'
    else
      convert(number)
    end
  end

  private

  # recursable conversion function, avoids the ein/eins-edge case
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

    result = illions(group_by_3_reverse(big))
    result << " " << convert(normal) unless normal.zero?
    result
  end

  def illions(groups_of_3)
    # All comments are examples of how the chain manipulates this array
    groups_of_3 # => 
      .zip(BIG)
      .reject { |amount, *| amount.zero? } # remove pairs with a value of zero
      .reverse
      .map { |amount, illion| "#{convert(amount)} #{pluralize(illion, amount)}" }
      .map { |str| str.gsub(/ein /, 'eine ') } # the illions are female
      .join(' ')
  end

  def pluralize(word, amount)
    if amount > 1
      word + (word.end_with?('e') ? 'n' : 'en')
    else
      word
    end
  end

  # 12345678 => [678, 345, 12]
  def group_by_3_reverse(number)
    [].tap do |groups|
      until number.zero?
        number, end_group = number.divmod(1000)
        groups << end_group
      end
    end
  end
end
