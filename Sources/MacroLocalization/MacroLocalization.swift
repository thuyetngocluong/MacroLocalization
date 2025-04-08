// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@freestanding(expression)
public macro localized(_ value: String) -> String = #externalMacro(module: "MacroLocalizationMacros", type: "LocalizedMacro")
