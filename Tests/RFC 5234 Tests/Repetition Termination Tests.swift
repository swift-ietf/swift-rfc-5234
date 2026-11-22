import RFC_5234
import Testing

enum `Repetition Termination Tests` {}

extension `Repetition Termination Tests` {
    @Suite
    struct `Repetition termination` {
        @Test
        func `an unbounded repetition of an optional stops at a byte it cannot match`() {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.optional(.terminal(.byte(0x61))), min: 0, max: nil)
            )

            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x62], against: rule)
            }
        }

        @Test
        func `a nested unbounded repetition stops at a byte it cannot match`() {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .sequence([
                    .repetition(.repetition(.terminal(.byte(0x61)), min: 0, max: nil), min: 0, max: nil),
                    .terminal(.byte(0x62)),
                ])
            )

            #expect(throws: Never.self) {
                try IETF.RFC.`5234`.Validator.validate([0x61, 0x61, 0x62], against: rule)
            }
        }

        @Test
        func `zero width repetitions satisfy a minimum`() throws {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .sequence([
                    .repetition(.optional(.terminal(.byte(0x61))), min: 3, max: nil),
                    .terminal(.byte(0x62)),
                ])
            )

            try IETF.RFC.`5234`.Validator.validate([0x62], against: rule)
        }

        @Test
        func `an unbounded repetition of an optional consumes every match`() throws {
            let rule = IETF.RFC.`5234`.Rule(
                name: "test",
                element: .repetition(.optional(.terminal(.byte(0x61))), min: 0, max: nil)
            )

            try IETF.RFC.`5234`.Validator.validate([0x61, 0x61, 0x61], against: rule)
        }
    }
}
