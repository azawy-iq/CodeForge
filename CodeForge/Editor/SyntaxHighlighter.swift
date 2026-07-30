//
//  SyntaxHighlighter.swift
//  تلوين بسيط للكلمات المفتاحية في Swift (Regex-based، وليس Parser كامل)
//

import SwiftUI

enum SyntaxHighlighter {

    private static let keywords: Set<String> = [
        "func", "var", "let", "if", "else", "guard", "return", "struct",
        "class", "enum", "import", "extension", "protocol", "for", "in",
        "while", "switch", "case", "default", "self", "true", "false",
        "nil", "private", "public", "static", "init", "do", "try", "catch",
        "throws", "async", "await", "@State", "@Published", "@main"
    ]

    static func highlight(_ code: String) -> AttributedString {
        var attributed = AttributedString(code)

        // تلوين الكلمات المفتاحية باللون البنفسجي
        for keyword in keywords {
            var searchRange = code.startIndex..<code.endIndex
            while let range = code.range(of: "\\b\(keyword)\\b", options: .regularExpression, range: searchRange) {
                if let attrRange = Range(range, in: attributed) {
                    attributed[attrRange].foregroundColor = .pink
                    attributed[attrRange].font = .system(.body, design: .monospaced).bold()
                }
                searchRange = range.upperBound..<code.endIndex
            }
        }

        // تلوين التعليقات (// ...) باللون الرمادي
        let lines = code.components(separatedBy: "\n")
        var offset = code.startIndex
        for line in lines {
            if let commentRange = line.range(of: "//.*", options: .regularExpression) {
                let lineStart = offset
                let absoluteStart = code.index(lineStart, offsetBy: line.distance(from: line.startIndex, to: commentRange.lowerBound))
                let absoluteEnd = code.index(absoluteStart, offsetBy: line.distance(from: commentRange.lowerBound, to: commentRange.upperBound))
                if let attrRange = Range(absoluteStart..<absoluteEnd, in: attributed) {
                    attributed[attrRange].foregroundColor = .green
                }
            }
            offset = code.index(offset, offsetBy: line.count + 1, limitedBy: code.endIndex) ?? code.endIndex
        }

        return attributed
    }
}
