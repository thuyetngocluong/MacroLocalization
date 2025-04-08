// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "MacroLocalization",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MacroLocalization",
            targets: ["MacroLocalization"]
        ),
//        .executable(
//            name: "MacroLocalizationClient",
//            targets: ["MacroLocalizationClient"]
//        ),
        .executable(
            name: "RecordScanner",
            targets: ["RecordScanner"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "MacroLocalizationMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        
        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(
            name: "MacroLocalization",
            dependencies: ["MacroLocalizationMacros"]
        ),
        
        // A client of the library, which is able to use the macro in its own code.
//        .executableTarget(name: "MacroLocalizationClient", dependencies: ["MacroLocalization"]),
        .executableTarget(
            name: "RecordScanner",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
    ]
)
