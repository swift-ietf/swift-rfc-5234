extension RFC_5234 {

    public enum Validator {}
}

extension RFC_5234.Validator {

    public static func validate(
        _ bytes: [UInt8],
        against rule: RFC_5234.Rule
    ) throws(Error) {
        try validate(bytes, against: rule, in: [])
    }

    public static func validate(
        _ bytes: [UInt8],
        against rule: RFC_5234.Rule,
        in grammar: [RFC_5234.Rule]
    ) throws(Error) {
        var rules: [String: RFC_5234.Rule] = [:]
        for core in RFC_5234.CoreRules.all.values {
            rules[core.name.lowercased()] = core
        }
        for defined in grammar {
            rules[defined.name.lowercased()] = defined
        }
        rules[rule.name.lowercased()] = rule
        var matcher = Matcher(
            bytes: bytes,
            rules: rules,
            expanding: [Expansion(name: rule.name.lowercased(), offset: 0)]
        )
        let ends = try matcher.ends(of: rule.element, from: 0)
        guard let consumed = ends.max() else {
            throw Error.doesNotMatch(rule.name)
        }
        guard consumed == bytes.count else {
            throw Error.incompleteMatch(
                rule.name,
                consumed: consumed,
                total: bytes.count
            )
        }
    }
}

extension RFC_5234.Validator {
    private struct Expansion: Hashable {
        let name: String
        let offset: Int
    }

    private struct Matcher {
        let bytes: [UInt8]
        let rules: [String: RFC_5234.Rule]
        var expanding: Set<Expansion>
        var memo: [Expansion: Set<Int>] = [:]

        mutating func ends(
            of element: RFC_5234.Element,
            from offset: Int
        ) throws(Error) -> Set<Int> {
            switch element {
            case .terminal(let terminal):
                let length: Int
                switch terminal.matcher {
                case .string(let string, _):
                    length = string.utf8.count
                case .byteValue, .byteRange:
                    length = 1
                }
                guard offset + length <= bytes.count,
                    terminal.matches(Array(bytes[offset..<(offset + length)]))
                else { return [] }
                return [offset + length]

            case .sequence(let elements):
                var positions: Set<Int> = [offset]
                for element in elements {
                    var next: Set<Int> = []
                    for position in positions {
                        next.formUnion(try ends(of: element, from: position))
                    }
                    guard !next.isEmpty else { return [] }
                    positions = next
                }
                return positions

            case .alternation(let elements):
                var positions: Set<Int> = []
                for element in elements {
                    positions.formUnion(try ends(of: element, from: offset))
                }
                return positions

            case .optional(let element):
                return try ends(of: element, from: offset).union([offset])

            case .repetition(let element, let min, let max):
                if let max, max < min { return [] }
                var found: Set<Int> = min == 0 ? [offset] : []
                var frontier: Set<Int> = [offset]
                var count = 0
                while !frontier.isEmpty {
                    if let max, count >= max { break }
                    var next: Set<Int> = []
                    for position in frontier {
                        next.formUnion(try ends(of: element, from: position))
                    }
                    count += 1
                    if next == frontier {
                        found.formUnion(next)
                        break
                    }
                    if count >= min {
                        if max == nil { next.subtract(found) }
                        found.formUnion(next)
                    }
                    frontier = next
                }
                return found

            case .ruleReference(let name):
                guard let referenced = rules[name.lowercased()] else {
                    throw Error.unsupportedFeature("Undefined rule '\(name)'")
                }
                let expansion = Expansion(name: referenced.name.lowercased(), offset: offset)
                if let cached = memo[expansion] { return cached }
                guard expanding.insert(expansion).inserted else {
                    throw Error.unsupportedFeature("Left recursion in rule '\(referenced.name)'")
                }
                defer { expanding.remove(expansion) }
                let positions = try ends(of: referenced.element, from: offset)
                memo[expansion] = positions
                return positions
            }
        }
    }
}
