# swift-rfc-5234

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Modeling and evaluation of ABNF grammars as specified in RFC 5234.

## Standard Reference

- **RFC**: 5234
- **Title**: Augmented BNF for Syntax Specifications: ABNF

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-5234.git", from: "0.4.4")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 5234", package: "swift-rfc-5234")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
