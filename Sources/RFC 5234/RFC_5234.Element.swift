extension RFC_5234 {
    /// An element in an ABNF rule.
    ///
    /// Elements can be terminals (actual matching patterns) or references to other rules.
    public indirect enum Element: Hashable, Sendable, Codable {
        /// A terminal matching pattern
        case terminal(Terminal)

        /// A reference to another rule
        case ruleReference(String)

        /// A sequence of elements (concatenation)
        case sequence([Element])

        /// An alternation of elements (choice)
        case alternation([Element])

        /// An optional element (0 or 1 occurrences)
        case optional(Element)

        /// A repeated element (0 or more occurrences)
        case repetition(Element, min: Int, max: Int?)
    }
}
