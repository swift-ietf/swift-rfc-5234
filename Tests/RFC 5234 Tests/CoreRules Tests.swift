import RFC_5234
import Testing

enum `IETF.RFC.5234.CoreRules Tests` {}

extension `IETF.RFC.5234.CoreRules Tests` {
    @Suite
    struct Test {
        @Test
        func `ALPHA matches uppercase letters`() throws {
            let result: Result<Void, IETF.RFC.`5234`.Validator.Error> = (UInt8(0x41)...UInt8(0x5A))
                .reduce(.success(())) { partial, byte in
                    guard case .success = partial else { return partial }
                    do throws(IETF.RFC.`5234`.Validator.Error) {
                        try IETF.RFC.`5234`.Validator.validate([byte], against: IETF.RFC.`5234`.CoreRules.alpha)
                        return .success(())
                    } catch {
                        return .failure(error)
                    }
                }
            try result.get()
        }

        @Test
        func `ALPHA matches lowercase letters`() throws {
            let result: Result<Void, IETF.RFC.`5234`.Validator.Error> = (UInt8(0x61)...UInt8(0x7A))
                .reduce(.success(())) { partial, byte in
                    guard case .success = partial else { return partial }
                    do throws(IETF.RFC.`5234`.Validator.Error) {
                        try IETF.RFC.`5234`.Validator.validate([byte], against: IETF.RFC.`5234`.CoreRules.alpha)
                        return .success(())
                    } catch {
                        return .failure(error)
                    }
                }
            try result.get()
        }

        @Test
        func `ALPHA rejects digits`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x30], against: IETF.RFC.`5234`.CoreRules.alpha)
            }
        }

        @Test
        func `DIGIT matches 0-9`() throws {
            let result: Result<Void, IETF.RFC.`5234`.Validator.Error> = (UInt8(0x30)...UInt8(0x39))
                .reduce(.success(())) { partial, byte in
                    guard case .success = partial else { return partial }
                    do throws(IETF.RFC.`5234`.Validator.Error) {
                        try IETF.RFC.`5234`.Validator.validate([byte], against: IETF.RFC.`5234`.CoreRules.digit)
                        return .success(())
                    } catch {
                        return .failure(error)
                    }
                }
            try result.get()
        }

        @Test
        func `DIGIT rejects letters`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x41], against: IETF.RFC.`5234`.CoreRules.digit)
            }
        }

        @Test
        func `HEXDIG matches 0-9`() throws {
            let result: Result<Void, IETF.RFC.`5234`.Validator.Error> = (UInt8(0x30)...UInt8(0x39))
                .reduce(.success(())) { partial, byte in
                    guard case .success = partial else { return partial }
                    do throws(IETF.RFC.`5234`.Validator.Error) {
                        try IETF.RFC.`5234`.Validator.validate([byte], against: IETF.RFC.`5234`.CoreRules.hexdig)
                        return .success(())
                    } catch {
                        return .failure(error)
                    }
                }
            try result.get()
        }

        @Test
        func `HEXDIG matches A-F (uppercase)`() throws {
            for char in ["A", "B", "C", "D", "E", "F"] {
                try IETF.RFC.`5234`.Validator.validate(
                    Array(char.utf8),
                    against: IETF.RFC.`5234`.CoreRules.hexdig
                )
            }
        }

        @Test
        func `HEXDIG matches a-f (lowercase, case-insensitive)`() throws {
            for char in ["a", "b", "c", "d", "e", "f"] {
                try IETF.RFC.`5234`.Validator.validate(
                    Array(char.utf8),
                    against: IETF.RFC.`5234`.CoreRules.hexdig
                )
            }
        }

        @Test
        func `HEXDIG rejects G`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x47], against: IETF.RFC.`5234`.CoreRules.hexdig)
            }
        }

        @Test
        func `BIT matches 0 and 1`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x30], against: IETF.RFC.`5234`.CoreRules.bit)
            try IETF.RFC.`5234`.Validator.validate([0x31], against: IETF.RFC.`5234`.CoreRules.bit)
        }

        @Test
        func `BIT rejects 2`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x32], against: IETF.RFC.`5234`.CoreRules.bit)
            }
        }
    }
}

extension `IETF.RFC.5234.CoreRules Tests`.Test {
    @Suite
    struct Whitespace {
        @Test
        func `SP matches space`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x20], against: IETF.RFC.`5234`.CoreRules.sp)
        }

        @Test
        func `SP rejects tab`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x09], against: IETF.RFC.`5234`.CoreRules.sp)
            }
        }

        @Test
        func `HTAB matches tab`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x09], against: IETF.RFC.`5234`.CoreRules.htab)
        }

        @Test
        func `CR matches carriage return`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x0D], against: IETF.RFC.`5234`.CoreRules.cr)
        }

        @Test
        func `LF matches linefeed`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x0A], against: IETF.RFC.`5234`.CoreRules.lf)
        }

        @Test
        func `CRLF matches CR LF sequence`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x0D, 0x0A], against: IETF.RFC.`5234`.CoreRules.crlf)
        }

        @Test
        func `CRLF rejects just CR`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x0D], against: IETF.RFC.`5234`.CoreRules.crlf)
            }
        }

        @Test
        func `CRLF rejects just LF`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x0A], against: IETF.RFC.`5234`.CoreRules.crlf)
            }
        }

        @Test
        func `WSP matches space`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x20], against: IETF.RFC.`5234`.CoreRules.wsp)
        }

        @Test
        func `WSP matches tab`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x09], against: IETF.RFC.`5234`.CoreRules.wsp)
        }

        @Test
        func `WSP rejects other whitespace`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x0A], against: IETF.RFC.`5234`.CoreRules.wsp)
            }
        }
    }
}

extension `IETF.RFC.5234.CoreRules Tests`.Test {
    @Suite
    struct Punctuation {
        @Test
        func `DQUOTE matches double quote`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x22], against: IETF.RFC.`5234`.CoreRules.dquote)
        }

        @Test
        func `DQUOTE rejects single quote`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x27], against: IETF.RFC.`5234`.CoreRules.dquote)
            }
        }
    }
}

extension `IETF.RFC.5234.CoreRules Tests`.Test {
    @Suite
    struct `Character Ranges` {
        @Test
        func `VCHAR matches visible characters`() throws {

            try IETF.RFC.`5234`.Validator.validate([0x21], against: IETF.RFC.`5234`.CoreRules.vchar)
            try IETF.RFC.`5234`.Validator.validate([0x41], against: IETF.RFC.`5234`.CoreRules.vchar)
            try IETF.RFC.`5234`.Validator.validate([0x7E], against: IETF.RFC.`5234`.CoreRules.vchar)
        }

        @Test
        func `VCHAR rejects space`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x20], against: IETF.RFC.`5234`.CoreRules.vchar)
            }
        }

        @Test
        func `VCHAR rejects control characters`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x00], against: IETF.RFC.`5234`.CoreRules.vchar)
            }
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x1F], against: IETF.RFC.`5234`.CoreRules.vchar)
            }
        }

        @Test
        func `CHAR matches 7-bit ASCII (excluding NUL)`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x01], against: IETF.RFC.`5234`.CoreRules.char)
            try IETF.RFC.`5234`.Validator.validate([0x41], against: IETF.RFC.`5234`.CoreRules.char)
            try IETF.RFC.`5234`.Validator.validate([0x7F], against: IETF.RFC.`5234`.CoreRules.char)
        }

        @Test
        func `CHAR rejects NUL`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x00], against: IETF.RFC.`5234`.CoreRules.char)
            }
        }

        @Test
        func `CHAR rejects 8-bit values`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x80], against: IETF.RFC.`5234`.CoreRules.char)
            }
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0xFF], against: IETF.RFC.`5234`.CoreRules.char)
            }
        }

        @Test
        func `CTL matches control characters`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x00], against: IETF.RFC.`5234`.CoreRules.ctl)
            try IETF.RFC.`5234`.Validator.validate([0x09], against: IETF.RFC.`5234`.CoreRules.ctl)
            try IETF.RFC.`5234`.Validator.validate([0x1F], against: IETF.RFC.`5234`.CoreRules.ctl)
            try IETF.RFC.`5234`.Validator.validate([0x7F], against: IETF.RFC.`5234`.CoreRules.ctl)
        }

        @Test
        func `CTL rejects printable characters`() {
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x20], against: IETF.RFC.`5234`.CoreRules.ctl)
            }
            #expect(throws: IETF.RFC.`5234`.Validator.Error.self) {
                try IETF.RFC.`5234`.Validator.validate([0x41], against: IETF.RFC.`5234`.CoreRules.ctl)
            }
        }

        @Test
        func `OCTET matches all byte values`() throws {
            try IETF.RFC.`5234`.Validator.validate([0x00], against: IETF.RFC.`5234`.CoreRules.octet)
            try IETF.RFC.`5234`.Validator.validate([0x7F], against: IETF.RFC.`5234`.CoreRules.octet)
            try IETF.RFC.`5234`.Validator.validate([0x80], against: IETF.RFC.`5234`.CoreRules.octet)
            try IETF.RFC.`5234`.Validator.validate([0xFF], against: IETF.RFC.`5234`.CoreRules.octet)
        }
    }
}

extension `IETF.RFC.5234.CoreRules Tests`.Test {
    @Suite
    struct Lookup {
        @Test
        func `All core rules are in lookup dictionary`() {
            let expectedNames = [
                "ALPHA", "DIGIT", "HEXDIG", "BIT",
                "SP", "HTAB", "CR", "LF", "CRLF", "WSP",
                "DQUOTE",
                "VCHAR", "CHAR", "CTL", "OCTET",
            ]

            for name in expectedNames {
                #expect(IETF.RFC.`5234`.CoreRules.all[name] != nil, "Missing core rule: \(name)")
            }
        }

        @Test
        func `Lookup by name works`() throws {
            let digit = IETF.RFC.`5234`.CoreRules.all["DIGIT"]!
            try IETF.RFC.`5234`.Validator.validate([0x35], against: digit)
        }
    }
}
