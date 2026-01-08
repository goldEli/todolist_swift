import Foundation

final class TodoStorageService {
    static let shared = TodoStorageService()

    private let fileName = "todos.json"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private var fileURL: URL? {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("TodoList")
            .appendingPathComponent(fileName)
    }

    private init() {}

    func loadTodos() -> [Todo] {
        guard let url = fileURL else { return [] }

        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode([Todo].self, from: data)
        } catch {
            return []
        }
    }

    func saveTodos(_ todos: [Todo]) {
        guard let url = fileURL else { return }

        do {
            // Ensure the directory exists
            let directory = url.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            
            let data = try encoder.encode(todos)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save todos: \(error)")
        }
    }
}
