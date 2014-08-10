# Ziffern

**Number to text, in _German_!**

Handles _positive and negative_ numbers up to **125 digits**, with _unlimited decimals_.

```ruby
require 'ziffern'
converter = Ziffern.new

[1, -5, 99.99, 12345, 10**63].each do |number|
  puts converter.to_german(number)
end

# >> eins
# >> minus fünf
# >> neunundneunzig Komma neun neun
# >> zwölftausenddreihundertfünfundvierzig
# >> eine Dezilliarde
```
