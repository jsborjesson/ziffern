# Ziffern

**Number to text, in _German_!**

Handles _positive and negative_ numbers up to **126 digits**, with _unlimited decimals_.

Just create an instance of the class and use the `#to_german` method to convert numbers,
it accepts floats, integers and strings, and will raise subclasses of `ArgumentError` if
it is not able to handle what you pass in.

```ruby
require 'ziffern'
converter = Ziffern.new

converter.to_german 1           # => "eins"
converter.to_german -5          # => "minus fünf"
converter.to_german 12345       # => "zwölftausenddreihundertfünfundvierzig"
converter.to_german 99.99       # => "neunundneunzig Komma neun neun"
converter.to_german 0.00        # => "null Komma null"
converter.to_german '0.00'      # => "null Komma null null"
converter.to_german 10**125     # => "einhundert Vigintilliarden"
converter.to_german 'invalid'   # ~> Ziffern::InvalidNumberError
converter.to_german 10**126     # ~> Ziffern::TooLargeNumberError
```

## Testing

```bash
# ...is the default task
rake
```
