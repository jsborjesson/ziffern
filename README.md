# Ziffern

**Number to text, in _German_!**

Handles _positive and negative_ numbers up to **126 digits**, with _unlimited decimals_.

Just create an instance of the class and use the `#to_german` method to convert numbers,
it accepts floats, integers and strings, and will raise subclasses of `ArgumentError` if
it is not able to handle what you pass in.

```ruby
require 'ziffern'

Ziffern.to_text 1          # => "eins"
Ziffern.to_text -5         # => "minus fünf"
Ziffern.to_text 12345      # => "zwölftausenddreihundertfünfundvierzig"
Ziffern.to_text 99.99      # => "neunundneunzig Komma neun neun"
Ziffern.to_text 0.00       # => "null Komma null"
Ziffern.to_text '0.00'     # => "null Komma null null"
Ziffern.to_text 10**125    # => "einhundert Vigintilliarden"
Ziffern.to_text 'invalid'  # ~> Ziffern::InvalidNumberError
Ziffern.to_text 10**126    # ~> Ziffern::TooLargeNumberError
```

## Testing

```bash
# ...is the default task
rake
```
