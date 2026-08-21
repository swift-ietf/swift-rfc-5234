extension RFC_5234 {

    public indirect enum Element: Hashable, Sendable, Codable {

        case terminal(Terminal)

        case ruleReference(String)

        case sequence([Element])

        case alternation([Element])

        case optional(Element)

        case repetition(Element, min: Int, max: Int?)
    }
}
