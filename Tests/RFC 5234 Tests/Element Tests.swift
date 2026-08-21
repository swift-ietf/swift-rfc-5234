import RFC_5234
import Testing

extension RFC_5234.Element {
    @Suite("RFC_5234.Element - Sequence")
    struct Test {
        @Test
        func `Sequence matches concatenated elements`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .sequence([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            try RFC_5234.Validator.validate([0x41, 0x42], against: rule)
        }

        @Test
        func `Sequence rejects partial match`() {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .sequence([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            #expect(throws: RFC_5234.Validator.Error.self) {
                try RFC_5234.Validator.validate([0x41], against: rule)
            }
        }

        @Test
        func `Sequence rejects wrong order`() {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .sequence([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            #expect(throws: RFC_5234.Validator.Error.self) {
                try RFC_5234.Validator.validate([0x42, 0x41], against: rule)
            }
        }

        @Test
        func `Empty sequence matches empty input`() throws {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .sequence([])
            )

            try RFC_5234.Validator.validate([], against: rule)
        }
    }
}

extension RFC_5234.Element.Test {
    @Suite("RFC_5234.Element - Alternation")
    struct Alternation {
        @Test
        func `Alternation matches first option`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .alternation([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            try RFC_5234.Validator.validate([0x41], against: rule)
        }

        @Test
        func `Alternation matches second option`() throws {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .alternation([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            try RFC_5234.Validator.validate([0x42], against: rule)
        }

        @Test
        func `Alternation rejects non-matching input`() {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .alternation([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            #expect(throws: RFC_5234.Validator.Error.self) {
                try RFC_5234.Validator.validate([0x43], against: rule)
            }
        }

        @Test
        func `Alternation with many options`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .alternation([
                    .terminal(.byteRange(0x30, 0x39)),
                    .terminal(.string("A")),
                    .terminal(.string("B")),
                    .terminal(.string("C")),
                ])
            )

            try RFC_5234.Validator.validate([0x35], against: rule)
            try RFC_5234.Validator.validate([0x41], against: rule)
            try RFC_5234.Validator.validate([0x43], against: rule)
        }
    }
}

extension RFC_5234.Element.Test {
    @Suite("RFC_5234.Element - Optional")
    struct Optional {
        @Test
        func `Optional matches when present`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .optional(.terminal(.byte(0x41)))
            )

            try RFC_5234.Validator.validate([0x41], against: rule)
        }

        @Test
        func `Optional matches when absent`() throws {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .optional(.terminal(.byte(0x41)))
            )

            try RFC_5234.Validator.validate([], against: rule)
        }

        @Test
        func `Optional in sequence`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .sequence([
                    .terminal(.byte(0x41)),
                    .optional(.terminal(.byte(0x42))),
                    .terminal(.byte(0x43)),
                ])
            )

            try RFC_5234.Validator.validate([0x41, 0x42, 0x43], against: rule)
            try RFC_5234.Validator.validate([0x41, 0x43], against: rule)
        }
    }
}

extension RFC_5234.Element.Test {
    @Suite("RFC_5234.Element - Repetition")
    struct Repetition {
        @Test
        func `Repetition 0 or more (*) matches zero`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 0, max: nil)
            )

            try RFC_5234.Validator.validate([], against: rule)
        }

        @Test
        func `Repetition 0 or more (*) matches one`() throws {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 0, max: nil)
            )

            try RFC_5234.Validator.validate([0x41], against: rule)
        }

        @Test
        func `Repetition 0 or more (*) matches many`() throws {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 0, max: nil)
            )

            try RFC_5234.Validator.validate([0x41, 0x41, 0x41], against: rule)
        }

        @Test
        func `Repetition 1 or more (1*) requires at least one`() {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 1, max: nil)
            )

            #expect(throws: RFC_5234.Validator.Error.self) {
                try RFC_5234.Validator.validate([], against: rule)
            }
        }

        @Test
        func `Repetition 1 or more (1*) accepts one`() throws {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 1, max: nil)
            )

            try RFC_5234.Validator.validate([0x41], against: rule)
        }

        @Test
        func `Repetition 1 or more (1*) accepts many`() throws {
            let rule = RFC_5234.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 1, max: nil)
            )

            try RFC_5234.Validator.validate([0x41, 0x41], against: rule)
        }

        @Test
        func `Repetition with max (2*4)`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 2, max: 4)
            )

            #expect(throws: RFC_5234.Validator.Error.self) {
                try RFC_5234.Validator.validate([0x41], against: rule)
            }

            try RFC_5234.Validator.validate([0x41, 0x41], against: rule)
            try RFC_5234.Validator.validate([0x41, 0x41, 0x41], against: rule)
            try RFC_5234.Validator.validate([0x41, 0x41, 0x41, 0x41], against: rule)

            #expect(throws: RFC_5234.Validator.Error.self) {

                try RFC_5234.Validator.validate([0x41, 0x41, 0x41, 0x41, 0x41], against: rule)
            }
        }

        @Test
        func `Exact repetition (3A)`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 3, max: 3)
            )

            #expect(throws: RFC_5234.Validator.Error.self) {
                try RFC_5234.Validator.validate([0x41, 0x41], against: rule)
            }

            try RFC_5234.Validator.validate([0x41, 0x41, 0x41], against: rule)

            #expect(throws: RFC_5234.Validator.Error.self) {

                try RFC_5234.Validator.validate([0x41, 0x41, 0x41, 0x41], against: rule)
            }
        }
    }
}

extension RFC_5234.Element.Test {
    @Suite
    struct `Complex Combinations` {
        @Test
        func `Sequence of alternations`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .sequence([
                    .alternation([
                        .terminal(.byte(0x41)),
                        .terminal(.byte(0x42)),
                    ]),
                    .alternation([
                        .terminal(.byte(0x43)),
                        .terminal(.byte(0x44)),
                    ]),
                ])
            )

            try RFC_5234.Validator.validate([0x41, 0x43], against: rule)
            try RFC_5234.Validator.validate([0x41, 0x44], against: rule)
            try RFC_5234.Validator.validate([0x42, 0x43], against: rule)
            try RFC_5234.Validator.validate([0x42, 0x44], against: rule)
        }

        @Test
        func `Repetition of sequence`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .repetition(
                    .sequence([
                        .terminal(.byte(0x41)),
                        .terminal(.byte(0x42)),
                    ]),
                    min: 0,
                    max: nil
                )
            )

            try RFC_5234.Validator.validate([], against: rule)
            try RFC_5234.Validator.validate([0x41, 0x42], against: rule)
            try RFC_5234.Validator.validate([0x41, 0x42, 0x41, 0x42], against: rule)
        }

        @Test
        func `Optional repetition`() throws {

            let rule = RFC_5234.Rule(
                name: "test",
                element: .optional(
                    .repetition(.terminal(.byte(0x41)), min: 0, max: nil)
                )
            )

            try RFC_5234.Validator.validate([], against: rule)
            try RFC_5234.Validator.validate([0x41, 0x41], against: rule)
        }
    }
}
