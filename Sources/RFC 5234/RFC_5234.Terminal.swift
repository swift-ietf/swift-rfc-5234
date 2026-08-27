import ASCII
import ASCII_Standard_Library_Integration

extension RFC_5234 {

    public struct Terminal: Hashable, Sendable, Codable {
        let matcher: Matcher
    }
}

extension RFC_5234.Terminal {

    public static func string(_ string: String) -> Self {
        Self(matcher: .string(string, caseSensitive: false))
    }

    @_spi(RFC_7405)
    public static func caseSensitiveString(_ string: String) -> Self {
        Self(matcher: .string(string, caseSensitive: true))
    }

    public static func byte(_ byte: UInt8) -> Self {
        Self(matcher: .byteValue(byte))
    }

    public static func byteRange(_ lower: UInt8, _ upper: UInt8) -> Self {
        Self(matcher: .byteRange(lower, upper))
    }

    public func matches(_ bytes: [UInt8]) -> Bool {
        switch matcher {
        case .string(let string, let caseSensitive):
            let stringBytes = Array(string.utf8)
            guard bytes.count == stringBytes.count else { return false }
            if caseSensitive {
                return bytes == stringBytes
            } else {
                return zip(bytes, stringBytes).allSatisfy { byte, expected in
                    let lower = ASCII.Case.Conversion.convert(byte, to: .lower)
                    let expectedLower = ASCII.Case.Conversion.convert(
                        expected,
                        to: .lower
                    )
                    return lower == expectedLower
                }
            }

        case .byteValue(let value):
            return bytes.count == 1 && bytes[0] == value

        case .byteRange(let lower, let upper):
            return bytes.count == 1 && bytes[0] >= lower && bytes[0] <= upper
        }
    }
}
