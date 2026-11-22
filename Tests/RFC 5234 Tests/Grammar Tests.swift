import RFC_5234
import Testing

enum `Grammar Tests` {}

extension `Grammar Tests` {
    @Suite
    struct `RFC 5234 §2.2 rule references within a grammar` {
        let greeting = IETF.RFC.`5234`.Rule(
            name: "greeting",
            element: .sequence([.ruleReference("word"), .ruleReference("SP"), .ruleReference("word")])
        )

        let word = IETF.RFC.`5234`.Rule(
            name: "word",
            element: .repetition(.ruleReference("ALPHA"), min: 1, max: nil)
        )

        @Test
        func `a rule referencing another rule of the grammar validates matching input`() throws {
            try IETF.RFC.`5234`.Validator.validate(Array("hello world".utf8), against: greeting, in: [greeting, word])
        }

        @Test
        func `a rule referencing another rule of the grammar rejects non-matching input`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.doesNotMatch("greeting")) {
                try IETF.RFC.`5234`.Validator.validate(Array("hello 42".utf8), against: greeting, in: [greeting, word])
            }
        }

        @Test
        func `a rule missing from the grammar is reported`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.unsupportedFeature("Undefined rule 'word'")) {
                try IETF.RFC.`5234`.Validator.validate(Array("hello world".utf8), against: greeting)
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `indirect left recursion through the grammar is reported`() {
            let a = IETF.RFC.`5234`.Rule(name: "a", element: .alternation([.sequence([.ruleReference("b"), .terminal(.byte(0x61))]), .terminal(.byte(0x61))]))
            let b = IETF.RFC.`5234`.Rule(name: "b", element: .ruleReference("a"))

            #expect(throws: IETF.RFC.`5234`.Validator.Error.unsupportedFeature("Left recursion in rule 'a'")) {
                try IETF.RFC.`5234`.Validator.validate([0x61, 0x61], against: a, in: [a, b])
            }
        }
    }
}
