import RFC_5234
import Testing

@Suite
struct `RFC 5234 §3.1 §3.2 §3.5 §3.6 any way of matching is accepted` {
    @Test
    func `a repetition gives back what a following element needs`() throws {
        let rule = RFC_5234.Rule(
            name: "number",
            element: .sequence([
                .repetition(.ruleReference("DIGIT"), min: 1, max: nil),
                .ruleReference("DIGIT"),
            ])
        )

        try RFC_5234.Validator.validate(Array("123".utf8), against: rule)
        try RFC_5234.Validator.validate(Array("12".utf8), against: rule)
        #expect(throws: RFC_5234.Validator.Error.self) {
            try RFC_5234.Validator.validate(Array("1".utf8), against: rule)
        }
    }

    @Test
    func `a later alternative is tried when an earlier one leaves the rest unmatched`() throws {
        let rule = RFC_5234.Rule(
            name: "test",
            element: .sequence([
                .alternation([.terminal(.string("a")), .terminal(.string("ab"))]),
                .terminal(.string("c")),
            ])
        )

        try RFC_5234.Validator.validate(Array("abc".utf8), against: rule)
        try RFC_5234.Validator.validate(Array("ac".utf8), against: rule)
    }

    @Test
    func `a bounded repetition gives back what a following element needs`() throws {
        let rule = RFC_5234.Rule(
            name: "test",
            element: .sequence([
                .repetition(.terminal(.string("a")), min: 2, max: 3),
                .terminal(.string("a")),
            ])
        )

        try RFC_5234.Validator.validate(Array("aaa".utf8), against: rule)
        try RFC_5234.Validator.validate(Array("aaaa".utf8), against: rule)
        #expect(throws: RFC_5234.Validator.Error.self) {
            try RFC_5234.Validator.validate(Array("aa".utf8), against: rule)
        }
        #expect(throws: RFC_5234.Validator.Error.self) {
            try RFC_5234.Validator.validate(Array("aaaaa".utf8), against: rule)
        }
    }

    @Test
    func `an optional element is skipped when matching it leaves the rest unmatched`() throws {
        let rule = RFC_5234.Rule(
            name: "test",
            element: .sequence([
                .optional(.terminal(.string("a"))),
                .terminal(.string("a")),
            ])
        )

        try RFC_5234.Validator.validate(Array("a".utf8), against: rule)
        try RFC_5234.Validator.validate(Array("aa".utf8), against: rule)
    }

    @Test(.timeLimit(.minutes(1)))
    func `nested unbounded repetitions finish quickly`() throws {
        let nested = RFC_5234.Element.repetition(
            .repetition(.terminal(.string("a")), min: 0, max: nil),
            min: 0,
            max: nil
        )
        let input = Array(repeating: UInt8(0x61), count: 30) + [0x62]

        #expect(throws: RFC_5234.Validator.Error.self) {
            try RFC_5234.Validator.validate(input, against: RFC_5234.Rule(name: "test", element: nested))
        }
        try RFC_5234.Validator.validate(
            input,
            against: RFC_5234.Rule(name: "test", element: .sequence([nested, .terminal(.string("b"))]))
        )
        #expect(throws: RFC_5234.Validator.Error.self) {
            try RFC_5234.Validator.validate(
                input,
                against: RFC_5234.Rule(
                    name: "test",
                    element: .sequence([nested, .terminal(.string("a")), .terminal(.string("c"))])
                )
            )
        }
    }
}
