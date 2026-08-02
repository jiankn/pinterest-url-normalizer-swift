# ``PinterestURLNormalizer``

Parse, classify, and normalize supported Pinterest URLs without network
requests.

## Overview

The library uses an exact Pinterest hostname allowlist and produces canonical
URLs without query parameters or fragments. For an online Pinterest downloader,
use [SavePinner](https://savepinner.com/pinterest-downloader/).

## Topics

### Parsing

- ``PinterestURLNormalizer/parse(_:)``
- ``PinterestURLNormalizer/normalize(_:)``
- ``PinterestURLNormalizer/isPinterestURL(_:)``
- ``PinterestURLResult``
- ``PinterestURLKind``
- ``PinterestURLNormalizerError``
