# swift-rfc-5234

Use this package when you need to check whether some bytes match a grammar written in ABNF, the notation RFCs use for their syntax. Build the grammar in Swift as `RFC_5234.Rule` values made of `RFC_5234.Element` cases, then check input with `RFC_5234.Validator.validate(_:against:in:)`. It does not read ABNF text and does not return a parse tree. The ABNF core rules such as `ALPHA` and `DIGIT` are in `RFC_5234.CoreRules`. For case-sensitive string literals, use swift-rfc-7405.

## Laws

- Input is accepted only if some way of matching the rule consumes all of it. Every alternative, every choice of an optional element and every repetition count is tried, so a repetition gives back what a following element needs: `1*DIGIT DIGIT` accepts `12`.
- When the rule matches nothing at the start of the input, validation fails with `RFC_5234.Validator.Error.doesNotMatch(_:)`. When the longest match stops short of the end, it fails with `RFC_5234.Validator.Error.incompleteMatch(_:consumed:total:)`, carrying how many bytes it consumed.
- Rule names are case-insensitive. A reference is resolved first to the rule being validated, then to the rules passed as the grammar, then to the core rules, so a grammar rule can replace a core rule of the same name.
- A reference to a rule that is not defined fails with `RFC_5234.Validator.Error.unsupportedFeature(_:)`. So does left recursion, where a rule is reached again at the same position without consuming input. A rule that refers to itself after consuming input works.
- String terminals match ASCII letters without regard to case, so `RFC_5234.CoreRules.hexdig` accepts `a` to `f` as well as `A` to `F`. Byte and byte range terminals match exactly.
- A repetition whose maximum is below its minimum matches nothing. An element that matches the empty string counts toward a repetition's minimum.
