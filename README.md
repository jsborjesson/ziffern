# Ziffern

**Number to text, in _German_!**

Handles _positive and negative_ numbers up to **125 digits**, with _unlimited decimals_.

```ruby
require 'ziffern'
converter = Ziffern.new

[1, -5, 12345, 99.99, '0.00', 10**63 + 1].each do |number|
  puts converter.to_german(number)
end

# >> eins
# >> minus fünf
# >> zwölftausenddreihundertfünfundvierzig
# >> neunundneunzig Komma neun neun
# >> null Komma null null
# >> eine Dezilliarde eins
```
