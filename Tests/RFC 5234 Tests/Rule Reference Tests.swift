import RFC_5234
import Testing

@Suite
struct `RFC 5234 §2.1 §2.2 rule references` {
    @Test
    func `a rule referencing a core rule validates matching input`() throws {
        let number = RFC_5234.Rule(
            name: "number",
            element: .repetition(.ruleReference("DIGIT"), min: 1, max: nil)
        )

        try RFC_5234.Validator.validate([0x31, 0x32, 0x33], against: number)
    }

    @Test
    func `a rule referencing a core rule rejects non-matching input`() {
        let number = RFC_5234.Rule(
            name: "number",
            element: .repetition(.ruleReference("DIGIT"), min: 1, max: nil)
        )

        #expect(throws: RFC_5234.Validator.Error.incompleteMatch("number", consumed: 2, total: 3)) {
            try RFC_5234.Validator.validate([0x31, 0x32, 0x61], against: number)
        }
        #expect(throws: RFC_5234.Validator.Error.doesNotMatch("number")) {
            try RFC_5234.Validator.validate([0x61], against: number)
        }
    }

    @Test
    func `rule names are case insensitive`() throws {
        let identifier = RFC_5234.Rule(
            name: "identifier",
            element: .sequence([
                .ruleReference("alpha"),
                .repetition(
                    .alternation([.ruleReference("Alpha"), .ruleReference("digit")]),
                    min: 0,
                    max: nil
                ),
            ])
        )

        try RFC_5234.Validator.validate([0x61, 0x31, 0x42], against: identifier)
        #expect(throws: RFC_5234.Validator.Error.doesNotMatch("identifier")) {
            try RFC_5234.Validator.validate([0x31, 0x61], against: identifier)
        }
    }

    @Test
    func `a rule referencing itself after consuming input recurses`() throws {
        let nested = RFC_5234.Rule(
            name: "nested",
            element: .alternation([
                .sequence([
                    .terminal(.byte(0x28)),
                    .optional(.ruleReference("NESTED")),
                    .terminal(.byte(0x29)),
                ])
            ])
        )

        try RFC_5234.Validator.validate([0x28, 0x28, 0x29, 0x29], against: nested)
        #expect(throws: RFC_5234.Validator.Error.self) {
            try RFC_5234.Validator.validate([0x28, 0x28, 0x29], against: nested)
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func `left recursion is reported instead of recursing forever`() {
        let list = RFC_5234.Rule(
            name: "list",
            element: .alternation([
                .sequence([.optional(.terminal(.byte(0x20))), .ruleReference("list"), .terminal(.byte(0x61))]),
                .terminal(.byte(0x61)),
            ])
        )

        #expect(throws: RFC_5234.Validator.Error.unsupportedFeature("Left recursion in rule 'list'")) {
            try RFC_5234.Validator.validate([0x61, 0x61], against: list)
        }
    }

    @Test
    func `an undefined rule is reported`() {
        let rule = RFC_5234.Rule(
            name: "test",
            element: .ruleReference("undefined-rule")
        )

        #expect(throws: RFC_5234.Validator.Error.unsupportedFeature("Undefined rule 'undefined-rule'")) {
            try RFC_5234.Validator.validate([0x61], against: rule)
        }
    }
}
