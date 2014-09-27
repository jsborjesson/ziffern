# Changelog

## v2.0.0.alpha

- Changed main interface from `Ziffern.new.to_german(number)` to `Ziffern.to_text(number)`
- Refactored from a single file into a more OO approach
    - Moved files into lib and spec folders
    - Broke up previous functionality into basic(`GermanInteger`), bignums(`GermanBigInteger`) and decimal(`GermanFloat`) conversion
    - There are now composable classes from which you can inherit to get new behaviour easily
    - The new classes can also be used by themselves without the module interface
    - All number classes have `#to_i` and `#to_f` methods.
- Added Ruby 2.0 version requirement
- Added currency conversion with a `Ziffern.to_euro` method backed by the more general `GermanCurrency` class.

## v1.1.2

Running the test is now the default task, just run `rake`.

Minor style tweaks.

## v1.1.1

Just some renamings and tweaks for readability.

## v1.1.0

Too large numbers now raise `Ziffern::TooLargeNumberError`. It is a subclass
of `ArgumentError` so catching that still works.

Completely invalid inputs now raise `Ziffern::InvalidNumberError` instead of
wrongly returning `"null"`.

NOTE: Raising on invalid input arguably broke the semver convention because it
does **not** fix the bug in a backwards-compatible manner.

## v1.0.3

Numbers between 0 and -1 now correctly shown as negative.

## v1.0.2

Negative numbers passed in as strings now handled correctly.

## v1.0.1

Pure refactor.

## v1.0.0

Initial release.
