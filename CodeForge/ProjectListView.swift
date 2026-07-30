//
//  ProjectListView.swift
//  الشاشة الرئيسية: قائمة ملفات المشروع
//

import SwiftUI

struct ProjectListView: View {
    @StateObject private var manager = ProjectFileManager.shared
    @State private var showNewFileAlert = false
    @State private var newFileName = ""
    @State private var showExporter = false

    var body: some View {
        NavigationView {
            List {
                ForEach(manager.files) { file in
                    NavigationLink(destination: CodeEditorView(file: file)) {
                        Label(file.name, systemImage: "swift")
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { manager.delete(manager.files[$0]) }
                }
            }
            .navigationTitle("مشروعي — CodeForge")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewFileAlert = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .alert("ملف جديد", isPresented: $showNewFileAlert) {
                TextField("اسم الملف (مثال: Model)", text: $newFileName)
                Button("إنشاء") {
                    if !newFileName.isEmpty {
                        manager.createFile(named: newFileName)
                        newFileName = ""
                    }
                }
                Button("إلغاء", role: .cancel) {}
            }
            .overlay {
                if manager.files.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("لا يوجد ملفات بعد — اضغط + لإنشاء أول ملف")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .onAppear { manager.refresh() }
    }
}
