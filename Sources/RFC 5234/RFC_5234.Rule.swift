extension RFC_5234 {

    public struct Rule: Hashable, Sendable, Codable {

        public let name: String

        public let element: Element

        public init(
            name: String,
            element: Element
        ) {
            self.name = name
            self.element = element
        }
    }
}
