// swift-tools-version: 6.4

import PackageDescription

// RFC 5234: Augmented BNF for Syntax Specifications: ABNF
//
// Implements RFC 5234 ABNF (Augmented Backus-Naur Form) for defining
// syntax specifications used throughout IETF standards.
//
// ABNF is a metalanguage for describing the syntax of protocols and
// data formats. It provides a formal notation for specifying grammars
// with terminals, rules, repetition, alternatives, and grouping.
//
// This is a pure Swift implementation with no Foundation dependencies,
// suitable for Swift Embedded and constrained environments.

let package = Package(
    name: "swift-rfc-5234",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
    ],
    products: [
        .library(
            name: "RFC 5234",
            targets: ["RFC 5234"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-standard-library-extensions.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-ascii-primitives.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-incits/swift-incits-4-1986.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "RFC 5234",
            dependencies: [
                .product(
                    name: "Standard Library Extensions",
                    package: "swift-standard-library-extensions"
                ),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
                .product(name: "INCITS 4 1986", package: "swift-incits-4-1986"),
            ]
        ),
        .testTarget(
            name: "RFC 5234 Tests",
            dependencies: [
                "RFC 5234"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
