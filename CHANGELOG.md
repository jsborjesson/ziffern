# Changelog

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
