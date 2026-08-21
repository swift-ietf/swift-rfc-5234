extension RFC_5234.Validator {

    public enum Error: Swift.Error, Sendable, Equatable {
        case doesNotMatch(String)
        case incompleteMatch(String, consumed: Int, total: Int)
        case unsupportedFeature(String)
    }

    @available(*, deprecated, renamed: "Error")
    public typealias ValidationError = RFC_5234.Validator.Error
}

extension RFC_5234.Validator.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .doesNotMatch(let ruleName):
            return "Input does not match rule '\(ruleName)'"

        case .incompleteMatch(let ruleName, let consumed, let total):
            return "Incomplete match for rule '\(ruleName)': consumed \(consumed) of \(total) bytes"

        case .unsupportedFeature(let feature):
            return "Unsupported feature: \(feature)"
        }
    }
}
