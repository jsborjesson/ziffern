# Ziffern

**Number to text, in _German_!**

```ruby
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
