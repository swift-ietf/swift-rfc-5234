import RFC_5234
import Testing

@Suite
struct `RFC 5234 §2.2 rule references within a grammar` {
    let greeting = RFC_5234.Rule(
        name: "greeting",
        element: .sequence([.ruleReference("word"), .ruleReference("SP"), .ruleReference("word")])
    )

    let word = RFC_5234.Rule(
        name: "word",
        element: .repetition(.ruleReference("ALPHA"), min: 1, max: nil)
    )

    @Test
    func `a rule referencing another rule of the grammar validates matching input`() throws {
        try RFC_5234.Validator.validate(Array("hello world".utf8), against: greeting, in: [greeting, word])
    }

    @Test
    func `a rule referencing another rule of the grammar rejects non-matching input`() {
        #expect(throws: RFC_5234.Validator.Error.doesNotMatch("greeting")) {
            try RFC_5234.Validator.validate(Array("hello 42".utf8), against: greeting, in: [greeting, word])
        }
    }

    @Test
    func `a rule missing from the grammar is reported`() {
        #expect(throws: RFC_5234.Validator.Error.unsupportedFeature("Undefined rule 'word'")) {
            try RFC_5234.Validator.validate(Array("hello world".utf8), against: greeting)
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func `indirect left recursion through the grammar is reported`() {
        let a = RFC_5234.Rule(name: "a", element: .alternation([.sequence([.ruleReference("b"), .terminal(.byte(0x61))]), .terminal(.byte(0x61))]))
        let b = RFC_5234.Rule(name: "b", element: .ruleReference("a"))

        #expect(throws: RFC_5234.Validator.Error.unsupportedFeature("Left recursion in rule 'a'")) {
            try RFC_5234.Validator.validate([0x61, 0x61], against: a, in: [a, b])
        }
    }
}
