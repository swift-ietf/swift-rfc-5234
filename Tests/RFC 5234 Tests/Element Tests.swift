import RFC_5234
import Testing

enum `IETF.RFC.5234.Element Tests` {}

extension `IETF.RFC.5234.Element Tests` {
    @Suite
    struct Test {
        @Test
        func `Sequence matches concatenated elements`() throws {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .sequence([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            try IETF.RFC.`5234`.Validator.validate([0x41, 0x42], against: rule)
        }

        @Test
        func `Sequence rejects partial match`() {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .sequence([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x41], against: rule)
            }
        }

        @Test
        func `Sequence rejects wrong order`() {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .sequence([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x42, 0x41], against: rule)
            }
        }

        @Test
        func `Empty sequence matches empty input`() throws {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .sequence([])
            )

            try IETF.RFC.`5234`.Validator.validate([], against: rule)
        }
    }
}

extension `IETF.RFC.5234.Element Tests`.Test {
    @Suite
    struct Alternation {
        @Test
        func `Alternation matches first option`() throws {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .alternation([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            try IETF.RFC.`5234`.Validator.validate([0x41], against: rule)
        }

        @Test
        func `Alternation matches second option`() throws {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .alternation([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            try IETF.RFC.`5234`.Validator.validate([0x42], against: rule)
        }

        @Test
        func `Alternation rejects non-matching input`() {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .alternation([
                    .terminal(.byte(0x41)),
                    .terminal(.byte(0x42)),
                ])
            )

            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x43], against: rule)
            }
        }

        @Test
        func `Alternation with many options`() throws {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .alternation([
                    .terminal(.byteRange(0x30, 0x39)),
                    .terminal(.string("A")),
                    .terminal(.string("B")),
                    .terminal(.string("C")),
                ])
            )

            try IETF.RFC.`5234`.Validator.validate([0x35], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x41], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x43], against: rule)
        }
    }
}

extension `IETF.RFC.5234.Element Tests`.Test {
    @Suite
    struct Optional {
        @Test
        func `Optional matches when present`() throws {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .optional(.terminal(.byte(0x41)))
            )

            try IETF.RFC.`5234`.Validator.validate([0x41], against: rule)
        }

        @Test
        func `Optional matches when absent`() throws {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .optional(.terminal(.byte(0x41)))
            )

            try IETF.RFC.`5234`.Validator.validate([], against: rule)
        }

        @Test
        func `Optional in sequence`() throws {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .sequence([
                    .terminal(.byte(0x41)),
                    .optional(.terminal(.byte(0x42))),
                    .terminal(.byte(0x43)),
                ])
            )

            try IETF.RFC.`5234`.Validator.validate([0x41, 0x42, 0x43], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x41, 0x43], against: rule)
        }
    }
}

extension `IETF.RFC.5234.Element Tests`.Test {
    @Suite
    struct Repetition {
        @Test
        func `Repetition 0 or more (*) matches zero`() throws {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 0, max: nil)
            )

            try IETF.RFC.`5234`.Validator.validate([], against: rule)
        }

        @Test
        func `Repetition 0 or more (*) matches one`() throws {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 0, max: nil)
            )

            try IETF.RFC.`5234`.Validator.validate([0x41], against: rule)
        }

        @Test
        func `Repetition 0 or more (*) matches many`() throws {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 0, max: nil)
            )

            try IETF.RFC.`5234`.Validator.validate([0x41, 0x41, 0x41], against: rule)
        }

        @Test
        func `Repetition 1 or more (1*) requires at least one`() {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 1, max: nil)
            )

            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([], against: rule)
            }
        }

        @Test
        func `Repetition 1 or more (1*) accepts one`() throws {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 1, max: nil)
            )

            try IETF.RFC.`5234`.Validator.validate([0x41], against: rule)
        }

        @Test
        func `Repetition 1 or more (1*) accepts many`() throws {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 1, max: nil)
            )

            try IETF.RFC.`5234`.Validator.validate([0x41, 0x41], against: rule)
        }

        @Test
        func `Repetition with max (2*4)`() throws {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 2, max: 4)
            )

            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x41], against: rule)
            }

            try IETF.RFC.`5234`.Validator.validate([0x41, 0x41], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x41, 0x41, 0x41], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x41, 0x41, 0x41, 0x41], against: rule)

            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {

                try IETF.RFC.`5234`.Validator.validate([0x41, 0x41, 0x41, 0x41, 0x41], against: rule)
            }
        }

        @Test
        func `Exact repetition (3A)`() throws {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.terminal(.byte(0x41)), min: 3, max: 3)
            )

            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x41, 0x41], against: rule)
            }

            try IETF.RFC.`5234`.Validator.validate([0x41, 0x41, 0x41], against: rule)

            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {

                try IETF.RFC.`5234`.Validator.validate([0x41, 0x41, 0x41, 0x41], against: rule)
            }
        }
    }
}

extension `IETF.RFC.5234.Element Tests`.Test {
    @Suite
    struct `Complex Combinations` {
        @Test
        func `Sequence of alternations`() throws {

            let rule = IETF.RFC.`5234`.Rule(
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

            try IETF.RFC.`5234`.Validator.validate([0x41, 0x43], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x41, 0x44], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x42, 0x43], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x42, 0x44], against: rule)
        }

        @Test
        func `Repetition of sequence`() throws {

            let rule = IETF.RFC.`5234`.Rule(
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

            try IETF.RFC.`5234`.Validator.validate([], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x41, 0x42], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x41, 0x42, 0x41, 0x42], against: rule)
        }

        @Test
        func `Optional repetition`() throws {

            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .optional(
                    .repetition(.terminal(.byte(0x41)), min: 0, max: nil)
                )
            )

            try IETF.RFC.`5234`.Validator.validate([], against: rule)
            try IETF.RFC.`5234`.Validator.validate([0x41, 0x41], against: rule)
        }
    }
}
