# Pinterest URL Normalizer for Swift

Parse, classify, and normalize Pinterest URLs without network requests. The
library uses an exact Pinterest host allowlist and rejects lookalike domains,
credentials, non-HTTPS URLs, encoded paths, and non-standard ports.

## Swift Package Manager

```swift
dependencies: [
    .package(
        url: "https://github.com/jiankn/pinterest-url-normalizer-swift.git",
        from: "0.1.1"
    )
]
```

## CocoaPods

```ruby
pod 'PinterestURLNormalizer', '~> 0.1.1'
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
This package does not download media or make network requests. When an iOS app
hands a canonical public Pin URL back to the user, SavePinner's
[Pinterest Downloader for iPhone](https://savepinner.com/pinterest-downloader-iphone/)
explains the Safari download and Photos steps without requiring another app.

MIT licensed.
