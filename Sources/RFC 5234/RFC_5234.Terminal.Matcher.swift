extension RFC_5234.Terminal {
    enum Matcher: Hashable, Sendable, Codable {
        case string(String, caseSensitive: Bool)
        case byteValue(UInt8)
        case byteRange(UInt8, UInt8)
    }
}
