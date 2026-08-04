# ``PinterestURLNormalizer``

Parse, classify, and normalize supported Pinterest URLs without network
requests.

## Overview

The library uses an exact Pinterest hostname allowlist and produces canonical
URLs without query parameters or fragments. For the user-facing step on iOS,
continue with [SavePinner's iPhone download workflow](https://savepinner.com/pinterest-downloader-iphone/).

## Topics

### Parsing

- ``PinterestURLNormalizer/parse(_:)``
- ``PinterestURLNormalizer/normalize(_:)``
- ``PinterestURLNormalizer/isPinterestURL(_:)``
- ``PinterestURLResult``
- ``PinterestURLKind``
- ``PinterestURLNormalizerError``
