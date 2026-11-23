import ASCII

extension IETF.RFC.`5234` {

    public enum CoreRules {}
}

extension IETF.RFC.`5234`.CoreRules {

    public static let alpha = IETF.RFC.`5234`.Rule(
        name: "ALPHA",
        element: .alternation([
            .terminal(.byteRange(0x41, 0x5A)),
            .terminal(.byteRange(0x61, 0x7A)),
        ])
    )

    public static let digit = IETF.RFC.`5234`.Rule(
        name: "DIGIT",
        element: .terminal(.byteRange(0x30, 0x39))
    )

    public static let hexdig = IETF.RFC.`5234`.Rule(
        name: "HEXDIG",
        element: .alternation([
            .terminal(.byteRange(0x30, 0x39)),
            .terminal(.string("A")),
            .terminal(.string("B")),
            .terminal(.string("C")),
            .terminal(.string("D")),
            .terminal(.string("E")),
            .terminal(.string("F")),
        ])
    )

    public static let bit = IETF.RFC.`5234`.Rule(
        name: "BIT",
        element: .alternation([
            .terminal(.byte(0x30)),
            .terminal(.byte(0x31)),
        ])
    )
}

extension IETF.RFC.`5234`.CoreRules {

    public static let sp = IETF.RFC.`5234`.Rule(
        name: "SP",
        element: .terminal(.byte(INCITS.`4`.`1986`.SPACE.sp))
    )

    public static let htab = IETF.RFC.`5234`.Rule(
        name: "HTAB",
        element: .terminal(.byte(INCITS.`4`.`1986`.Character.Control.htab))
    )

    public static let cr = IETF.RFC.`5234`.Rule(
        name: "CR",
        element: .terminal(.byte(INCITS.`4`.`1986`.Character.Control.cr))
    )

    public static let lf = IETF.RFC.`5234`.Rule(
        name: "LF",
        element: .terminal(.byte(INCITS.`4`.`1986`.Character.Control.lf))
    )

    public static let crlf = IETF.RFC.`5234`.Rule(
        name: "CRLF",
        element: .sequence([
            .terminal(.byte(INCITS.`4`.`1986`.Character.Control.cr)),
            .terminal(.byte(INCITS.`4`.`1986`.Character.Control.lf)),
        ])
    )

    public static let wsp = IETF.RFC.`5234`.Rule(
        name: "WSP",
        element: .alternation([
            .terminal(.byte(INCITS.`4`.`1986`.SPACE.sp)),
            .terminal(.byte(INCITS.`4`.`1986`.Character.Control.htab)),
        ])
    )
}

extension IETF.RFC.`5234`.CoreRules {

    public static let dquote = IETF.RFC.`5234`.Rule(
        name: "DQUOTE",
        element: .terminal(.byte(INCITS.`4`.`1986`.Character.Graphic.quotationMark))
    )
}

extension IETF.RFC.`5234`.CoreRules {

    public static let vchar = IETF.RFC.`5234`.Rule(
        name: "VCHAR",
        element: .terminal(.byteRange(0x21, 0x7E))
    )

    public static let char = IETF.RFC.`5234`.Rule(
        name: "CHAR",
        element: .terminal(.byteRange(0x01, 0x7F))
    )

    public static let ctl = IETF.RFC.`5234`.Rule(
        name: "CTL",
        element: .alternation([
            .terminal(.byteRange(0x00, 0x1F)),
            .terminal(.byte(0x7F)),
        ])
    )

    public static let octet = IETF.RFC.`5234`.Rule(
        name: "OCTET",
        element: .terminal(.byteRange(0x00, 0xFF))
    )
}

extension IETF.RFC.`5234`.CoreRules {

    public static let all: [String: IETF.RFC.`5234`.Rule] = [
        "ALPHA": alpha,
        "DIGIT": digit,
        "HEXDIG": hexdig,
        "BIT": bit,
        "SP": sp,
        "HTAB": htab,
        "CR": cr,
        "LF": lf,
        "CRLF": crlf,
        "WSP": wsp,
        "DQUOTE": dquote,
        "VCHAR": vchar,
        "CHAR": char,
        "CTL": ctl,
        "OCTET": octet,
    ]
}
