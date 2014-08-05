# Ziffern

**Number to text, in _German_!**

```ruby
converter = Ziffern.new
[1, 5, 99, 12345, 987654321].each do |number|
  puts converter.to_german(number)
end

# >> eins
# >> fünf
# >> neunundneunzig
# >> zwölftausenddreihundertfünfundvierzig
# >> neunhundertsiebenundachtzig Millionen sechshundertvierundfünfzigtausenddreihunderteinundzwanzig
```
