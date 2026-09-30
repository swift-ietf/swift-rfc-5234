import RFC_5234
import Testing

@Suite
struct `Repetition termination` {
    @Test
    func `an unbounded repetition of an optional stops at a byte it cannot match`() {
        let rule = RFC_5234.Rule(
            name: "test",
            element: .repetition(.optional(.terminal(.byte(0x61))), min: 0, max: nil)
        )

        #expect(throws: RFC_5234.Validator.Error.self) {
            try RFC_5234.Validator.validate([0x62], against: rule)
        }
    }

    @Test
    func `a nested unbounded repetition stops at a byte it cannot match`() {
        let rule = RFC_5234.Rule(
            name: "test",
            element: .sequence([
                .repetition(.repetition(.terminal(.byte(0x61)), min: 0, max: nil), min: 0, max: nil),
                .terminal(.byte(0x62)),
            ])
        )

        #expect(throws: Never.self) {
            try RFC_5234.Validator.validate([0x61, 0x61, 0x62], against: rule)
        }
    }

    @Test
    func `zero width repetitions satisfy a minimum`() throws {
        let rule = RFC_5234.Rule(
            name: "test",
            element: .sequence([
                .repetition(.optional(.terminal(.byte(0x61))), min: 3, max: nil),
                .terminal(.byte(0x62)),
            ])
        )

        try RFC_5234.Validator.validate([0x62], against: rule)
    }

    @Test
    func `an unbounded repetition of an optional consumes every match`() throws {
        let rule = RFC_5234.Rule(
            name: "test",
            element: .repetition(.optional(.terminal(.byte(0x61))), min: 0, max: nil)
        )

        try RFC_5234.Validator.validate([0x61, 0x61, 0x61], against: rule)
    }
}
