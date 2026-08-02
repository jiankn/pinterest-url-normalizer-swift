import XCTest
@testable import PinterestURLNormalizer

final class PinterestURLNormalizerTests: XCTestCase {
    func testNormalizesRegionalPin() throws {
        let parsed = try PinterestURLNormalizer.parse(
            "https://www.pinterest.co.uk/pin/example--123456789/?utm_source=test"
        )

        XCTAssertEqual(parsed.kind, .pin)
        XCTAssertEqual(parsed.identifier, "123456789")
        XCTAssertEqual(parsed.normalizedURL, "https://www.pinterest.com/pin/123456789/")
    }

    func testSupportsShortProfileBoardAndIdeasURLs() throws {
        XCTAssertEqual(try PinterestURLNormalizer.parse("https://pin.it/AbC123").kind, .short)
        XCTAssertEqual(
            try PinterestURLNormalizer.parse("https://pinterest.com/savepinner").kind,
            .profile
        )
        XCTAssertEqual(
            try PinterestURLNormalizer.parse(
                "https://pinterest.com/savepinner/recipes"
            ).kind,
            .board
        )
        XCTAssertEqual(
            try PinterestURLNormalizer.parse(
                "https://pinterest.com/ideas/home-decor/12345"
            ).kind,
            .ideas
        )
    }

    func testRejectsUnsafeAndLookalikeURLs() {
        XCTAssertFalse(
            PinterestURLNormalizer.isPinterestURL("http://pinterest.com/pin/123")
        )
        XCTAssertFalse(
            PinterestURLNormalizer.isPinterestURL(
                "https://pinterest.com.evil.test/pin/123"
            )
        )
        XCTAssertFalse(
            PinterestURLNormalizer.isPinterestURL(
                "https://user:p@pinterest.com/pin/123"
            )
        )
        XCTAssertFalse(
            PinterestURLNormalizer.isPinterestURL(
                "https://pinterest.com:444/pin/123"
            )
        )
        XCTAssertFalse(
            PinterestURLNormalizer.isPinterestURL(
                "https://pinterest.com/pin/%31%32%33"
            )
        )
        XCTAssertThrowsError(
            try PinterestURLNormalizer.parse("https://pinterest.com/search/pins")
        )
    }
}
