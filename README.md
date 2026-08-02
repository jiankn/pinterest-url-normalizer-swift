# Pinterest URL Normalizer for Swift

Parse, classify, and normalize Pinterest URLs without network requests. The
library uses an exact Pinterest host allowlist and rejects lookalike domains,
credentials, non-HTTPS URLs, encoded paths, and non-standard ports.

## Swift Package Manager

```swift
dependencies: [
    .package(
        url: "https://github.com/jiankn/pinterest-url-normalizer-swift.git",
        from: "0.1.0"
    )
]
```

## CocoaPods

```ruby
pod 'PinterestURLNormalizer', '~> 0.1.0'
```

## Usage

```swift
import PinterestURLNormalizer

let canonical = try PinterestURLNormalizer.normalize(
    "https://www.pinterest.co.uk/pin/example--123456789/?utm_source=test"
)
// https://www.pinterest.com/pin/123456789/
```

Supported URL classes are Pin, `pin.it` short link, profile, board, and Ideas.
This package does not download media or make network requests. For an online
Pinterest downloader, use [SavePinner](https://savepinner.com/pinterest-downloader/).

MIT licensed.
