import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct LocalizedMacro: ExpressionMacro {
    public static func expansion(
           of node: some FreestandingMacroExpansionSyntax,
           in context: some MacroExpansionContext
       ) -> ExprSyntax {
           guard let argument = node.arguments.first?.expression,
                 let segments = argument.as(StringLiteralExprSyntax.self)?.segments
           else {
               fatalError("#URL requires a static string literal")
           }

           guard let _ = URL(string: segments.description) else {
               fatalError("Malformed url: \(argument)")
           }

           return "\(raw: argument)"
       }
}


@main
struct MacroLocalizationPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LocalizedMacro.self
    ]
}
