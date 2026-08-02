import Foundation

/// A supported Pinterest URL class.
public enum PinterestURLKind: String, Equatable, Sendable {
    case pin
    case short
    case profile
    case board
    case ideas
}

/// The parsed form of a supported Pinterest URL.
public struct PinterestURLResult: Equatable, Sendable {
    /// The class of Pinterest URL that was parsed.
    public let kind: PinterestURLKind

    /// The canonical URL without query parameters or fragments.
    public let normalizedURL: String

    /// The Pin ID, short-link token, username, or Ideas ID.
    public let identifier: String
}

/// An error raised for invalid or unsupported input.
public enum PinterestURLNormalizerError: Error, Equatable, Sendable {
    case invalidURL(String)
    case unsupportedURL(String)
}

/// Parses and normalizes supported Pinterest URLs without network requests.
public enum PinterestURLNormalizer {
    private static let canonicalHost = "www.pinterest.com"
    private static let countryHosts: Set<String> = [
        "pinterest.at", "pinterest.be", "pinterest.ca", "pinterest.ch",
        "pinterest.cl", "pinterest.co", "pinterest.co.kr", "pinterest.co.nz",
        "pinterest.co.uk", "pinterest.com.au", "pinterest.com.br",
        "pinterest.com.mx", "pinterest.com.pe", "pinterest.com.tr",
        "pinterest.cz", "pinterest.de", "pinterest.dk", "pinterest.es",
        "pinterest.fi", "pinterest.fr", "pinterest.gr", "pinterest.hu",
        "pinterest.id", "pinterest.ie", "pinterest.it", "pinterest.jp",
        "pinterest.nl", "pinterest.no", "pinterest.ph", "pinterest.pl",
        "pinterest.pt", "pinterest.ro", "pinterest.se", "pinterest.sk",
    ]
    private static let reserved: Set<String> = [
        "business", "categories", "explore", "help", "ideas", "login",
        "logout", "oauth", "pin", "resource", "search", "settings",
        "signup", "today", "topics",
    ]

    /// Returns the canonical form of a supported Pinterest URL.
    public static func normalize(_ input: String) throws -> String {
        try parse(input).normalizedURL
    }

    /// Returns whether the input is a supported Pinterest URL.
    public static func isPinterestURL(_ input: String) -> Bool {
        (try? parse(input)) != nil
    }

    /// Parses a URL into its class, canonical URL, and identifier.
    public static func parse(_ input: String) throws -> PinterestURLResult {
        let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty, value.count <= 2_048, !value.contains("\\") else {
            throw PinterestURLNormalizerError.invalidURL(
                "URL is empty, too long, or contains a backslash"
            )
        }

        guard let components = URLComponents(string: value),
              components.scheme?.lowercased() == "https",
              let rawHost = components.host,
              !rawHost.isEmpty
        else {
            throw PinterestURLNormalizerError.invalidURL("HTTPS URL required")
        }

        guard components.user == nil,
              components.password == nil,
              components.port == nil || components.port == 443
        else {
            throw PinterestURLNormalizerError.invalidURL(
                "credentials or non-standard port"
            )
        }

        guard !components.percentEncodedPath.contains("%") else {
            throw PinterestURLNormalizerError.invalidURL(
                "encoded paths are not supported"
            )
        }

        let host = rawHost.lowercased()
        let segments = components.path.split(separator: "/").map(String.init)

        if host == "pin.it" {
            return try parseShort(segments)
        }
        guard isPinterestHost(host) else {
            throw PinterestURLNormalizerError.invalidURL(
                "host is not an allowed Pinterest domain"
            )
        }
        return try parsePath(segments)
    }

    /// Returns whether a hostname exactly matches a supported Pinterest domain.
    public static func isPinterestHost(_ host: String) -> Bool {
        let value = host.lowercased()
        if ["pinterest.com", "www.pinterest.com", "m.pinterest.com"].contains(value) {
            return true
        }
        if countryHosts.contains(value) {
            return true
        }
        return value.hasPrefix("www.") && countryHosts.contains(String(value.dropFirst(4)))
    }

    private static func parseShort(_ segments: [String]) throws -> PinterestURLResult {
        guard segments.count == 1,
              matches(segments[0], pattern: "^[A-Za-z0-9]{2,}$")
        else {
            throw PinterestURLNormalizerError.unsupportedURL("unsupported pin.it path")
        }
        return result(.short, "https://pin.it/\(segments[0])/", segments[0])
    }

    private static func parsePath(_ segments: [String]) throws -> PinterestURLResult {
        if (segments.count == 2 || segments.count == 3), segments[0] == "pin" {
            let trailingSlug = segments.count == 3 ? segments[2] : nil
            return try parsePin(segments[1], trailingSlug: trailingSlug)
        }

        if segments.count == 3,
           segments[0] == "ideas",
           matches(segments[1], pattern: "^[A-Za-z0-9][A-Za-z0-9_-]*$"),
           matches(segments[2], pattern: "^[0-9]{1,20}$")
        {
            return result(
                .ideas,
                "https://\(canonicalHost)/ideas/\(segments[1])/\(segments[2])/",
                segments[2]
            )
        }

        if segments.count == 1, validUsername(segments[0]) {
            return result(
                .profile,
                "https://\(canonicalHost)/\(segments[0])/",
                segments[0]
            )
        }

        if segments.count == 2,
           validUsername(segments[0]),
           matches(segments[1], pattern: "^[A-Za-z0-9][A-Za-z0-9_-]*$")
        {
            return result(
                .board,
                "https://\(canonicalHost)/\(segments[0])/\(segments[1])/",
                segments[0]
            )
        }

        throw PinterestURLNormalizerError.unsupportedURL("unsupported Pinterest path")
    }

    private static func parsePin(
        _ pin: String,
        trailingSlug: String?
    ) throws -> PinterestURLResult {
        let identifier: String?
        if matches(pin, pattern: "^[0-9]{1,20}$") {
            identifier = pin
        } else {
            identifier = capture(pin, pattern: "^.*--([0-9]{1,20})$")
        }

        let validTrailingSlug = trailingSlug.map {
            matches($0, pattern: "^[A-Za-z0-9][A-Za-z0-9_-]*$")
        } ?? true

        guard let identifier, validTrailingSlug
        else {
            throw PinterestURLNormalizerError.unsupportedURL("unsupported Pinterest path")
        }

        return result(
            .pin,
            "https://\(canonicalHost)/pin/\(identifier)/",
            identifier
        )
    }

    private static func validUsername(_ value: String) -> Bool {
        matches(value, pattern: "^[A-Za-z0-9_][A-Za-z0-9_.-]*$") &&
            !reserved.contains(value.lowercased())
    }

    private static func matches(_ value: String, pattern: String) -> Bool {
        value.range(of: pattern, options: .regularExpression) != nil
    }

    private static func capture(_ value: String, pattern: String) -> String? {
        guard let expression = try? NSRegularExpression(pattern: pattern),
              let match = expression.firstMatch(
                  in: value,
                  range: NSRange(value.startIndex..., in: value)
              ),
              match.numberOfRanges > 1,
              let range = Range(match.range(at: 1), in: value)
        else {
            return nil
        }
        return String(value[range])
    }

    private static func result(
        _ kind: PinterestURLKind,
        _ normalizedURL: String,
        _ identifier: String
    ) -> PinterestURLResult {
        PinterestURLResult(
            kind: kind,
            normalizedURL: normalizedURL,
            identifier: identifier
        )
    }
}
