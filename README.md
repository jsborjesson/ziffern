# Ziffern

**Number to text, in _German_!**

Handles _positive and negative_ numbers up to **126 digits**, with _unlimited decimals_.

Just create an instance of the class and use the `#to_german` method to convert numbers,
it accepts floats, integers and strings, and will raise subclasses of `ArgumentError` if
it is not able to handle what you pass in.

```ruby
require 'ziffern'

# normal number conversion
Ziffern.to_text 1          # => "eins"
Ziffern.to_text -5         # => "minus fünf"
Ziffern.to_text 12345      # => "zwölftausenddreihundertfünfundvierzig"
Ziffern.to_text 99.99      # => "neunundneunzig Komma neun neun"
Ziffern.to_text 0.00       # => "null Komma null"
Ziffern.to_text '0.00'     # => "null Komma null null"
Ziffern.to_text 10**125    # => "einhundert Vigintilliarden"
Ziffern.to_text 'invalid'  # ~> Ziffern::InvalidNumberError
Ziffern.to_text 10**126    # ~> Ziffern::TooLargeNumberError

# currency
Ziffern.to_euro 5      # => "fünf Euro",
Ziffern.to_euro 5.0    # => "fünf Euro",
Ziffern.to_euro 5.5    # => "fünf Euro und fünfzig Cent",
Ziffern.to_euro 5.55   # => "fünf Euro und fünfundfünfzig Cent",
Ziffern.to_euro 5.555  # => "fünf Euro und sechsundfünfzig Cent",
```

## Testing

```bash
# ...is the default task
rake
```

## Release checklist

- run the tests
- make sure the readme examples are correct
- bump the version in `ziffern.gemspec` according to semver.
- update the changelog
- `rake release`

