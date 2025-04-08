// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@freestanding(expression)
public macro localized(_ value: String) -> String = #externalMacro(module: "MacroLocalizationMacros", type: "LocalizedMacro")

@freestanding(expression)
public macro LocalizedStringKey(_ value: String) -> LocalizedStringKey = #externalMacro(module: "MacroLocalizationMacros", type: "LocalizedStringKeyMacro")
