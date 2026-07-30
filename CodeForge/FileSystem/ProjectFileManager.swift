//
//  ProjectFileManager.swift
//  يدير ملفات ومجلدات المشروع داخل Documents الخاصة بالتطبيق
//

import Foundation

struct CodeFile: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let url: URL
}

final class ProjectFileManager: ObservableObject {

    static let shared = ProjectFileManager()

    @Published var files: [CodeFile] = []

    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    init() {
        refresh()
    }

    // تحديث قائمة الملفات الموجودة
    func refresh() {
        let fm = FileManager.default
        guard let items = try? fm.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) else {
            files = []
            return
        }
        files = items
            .filter { $0.pathExtension == "swift" || $0.pathExtension == "md" || $0.pathExtension == "plist" }
            .map { CodeFile(name: $0.lastPathComponent, url: $0) }
            .sorted { $0.name < $1.name }
    }

    // إنشاء ملف جديد فارغ
    @discardableResult
    func createFile(named name: String) -> CodeFile? {
        let safeName = name.hasSuffix(".swift") ? name : "\(name).swift"
        let url = documentsURL.appendingPathComponent(safeName)

        guard !FileManager.default.fileExists(atPath: url.path) else { return nil }

        let template = """
        // \(safeName)
        // أُنشئ عبر CodeForge

        import Foundation

        """
        try? template.write(to: url, atomically: true, encoding: .utf8)
        refresh()
        return CodeFile(name: safeName, url: url)
    }

    // قراءة محتوى ملف
    func read(_ file: CodeFile) -> String {
        (try? String(contentsOf: file.url, encoding: .utf8)) ?? ""
    }

    // حفظ محتوى ملف
    func save(_ content: String, to file: CodeFile) {
        try? content.write(to: file.url, atomically: true, encoding: .utf8)
    }

    // حذف ملف
    func delete(_ file: CodeFile) {
        try? FileManager.default.removeItem(at: file.url)
        refresh()
    }

    // مسار مجلد Documents (يفيد لو تبي تفتحه من تطبيق "الملفات")
    var documentsPath: String {
        documentsURL.path
    }
}
