//
//  CodeEditorView.swift
//  شاشة تحرير محتوى ملف كود واحد، مع تلوين بسيط وحفظ تلقائي
//

import SwiftUI

struct CodeEditorView: View {
    let file: CodeFile
    @ObservedObject private var manager = ProjectFileManager.shared

    @State private var content: String = ""
    @State private var showPreview = false

    var body: some View {
        VStack(spacing: 0) {
            if showPreview {
                ScrollView {
                    Text(SyntaxHighlighter.highlight(content))
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                TextEditor(text: $content)
                    .font(.system(.body, design: .monospaced))
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .padding(4)
            }
        }
        .navigationTitle(file.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button {
                        showPreview.toggle()
                    } label: {
                        Image(systemName: showPreview ? "pencil" : "eye")
                    }
                    Button {
                        manager.save(content, to: file)
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
            }
        }
        .onAppear { content = manager.read(file) }
        .onChange(of: content) { newValue in
            // حفظ تلقائي فوري مع كل تعديل
            manager.save(newValue, to: file)
        }
    }
}
