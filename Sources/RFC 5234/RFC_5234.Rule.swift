extension RFC_5234 {
    /// An ABNF rule definition.
    ///
    /// A rule consists of a name and an element that defines the pattern to match.
    public struct Rule: Hashable, Sendable, Codable {
        /// The name of the rule
        public let name: String

        /// The element that defines the pattern
        public let element: Element

        /// Creates a new ABNF rule.
        ///
        /// - Parameters:
        ///   - name: The name of the rule
        ///   - element: The element that defines the pattern
        public init(
            name: String,
            element: Element
        ) {
            self.name = name
            self.element = element
        }
    }
}
