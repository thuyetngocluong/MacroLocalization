
import Foundation
import SwiftSyntax
import SwiftParser
import ArgumentParser

final class RecordMacroVisitor: SyntaxVisitor {
    var recordedStrings: [String] = []
    
    override func visit(_ node: MacroExpansionExprSyntax) -> SyntaxVisitorContinueKind {
        // Tìm macro #record(...)
        if node.macroName.text == "localized" || node.macroName.text == "LocalizedStringKey",
           let firstArg = node.arguments.first?.expression.as(StringLiteralExprSyntax.self) {
            
            // Ghép các segments lại thành string đầy đủ
            let value = firstArg.segments.compactMap { segment -> String? in
                if case .stringSegment(let str) = segment {
                    return str.content.text
                }
                return nil
            }.joined()
            
            recordedStrings.append(value)
        }
        
        return .visitChildren
    }
}

@main
struct RecordScannerMain: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "Đường dẫn tới thư mục")
    var path: String
    
    func run() throws {
        // 📁 Đọc tất cả file .swift trong thư mục Sources
        let sourceRoot = URL(fileURLWithPath: path)
        var recordedStrings: [String] = []
        
        func collectStrings(from fileURL: URL) {
            guard let source = try? String(contentsOf: fileURL) else { return }
            let visistor = RecordMacroVisitor(viewMode: .all)
            visistor.walk(Parser.parse(source: source))
            recordedStrings.append(contentsOf: visistor.recordedStrings)
        }
        
        // 🔍 Quét tất cả file Swift trong Sources/
        let fileManager = FileManager.default
        if let enumerator = fileManager.enumerator(at: sourceRoot, includingPropertiesForKeys: nil) {
            for case let fileURL as URL in enumerator {
                if fileURL.pathExtension == "swift" {
                    collectStrings(from: fileURL)
                }
            }
        }
        
        // 📝 Ghi ra recorded.txt
        let outputURL = URL(fileURLWithPath: "./localized.generated.json")
        let output = try JSONSerialization.data(withJSONObject: recordedStrings)
        try output.write(to: outputURL)
        
        print("📄 Ghi \(recordedStrings.count) strings vào localized.generated.json")
    }
}
