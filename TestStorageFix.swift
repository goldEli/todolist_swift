#!/usr/bin/env swift

// Test script to verify TodoStorageService fix

import Foundation

// Recreate the Todo struct for testing
struct Todo: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

// Recreate the TodoStorageService for testing
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
            print("Load error: \(error)")
            return []
        }
    }

    func saveTodos(_ todos: [Todo]) {
        guard let url = fileURL else { 
            print("Could not get file URL")
            return 
        }

        do {
            // Ensure the directory exists (this is the fix!)
            let directory = url.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            print("Created directory: \(directory)")
            
            let data = try encoder.encode(todos)
            try data.write(to: url, options: .atomic)
            print("Saved todos to: \(url)")
        } catch {
            print("Save error: \(error)")
        }
    }
}

// Test the fix
print("Testing TodoStorageService fix...")

// Create test todos
let testTodos = [
    Todo(title: "Test todo 1"),
    Todo(title: "Test todo 2", isCompleted: true),
    Todo(title: "Test todo 3")
]

// Save the todos
print("\n1. Saving test todos...")
TodoStorageService.shared.saveTodos(testTodos)

// Load them back
print("\n2. Loading todos back...")
let loadedTodos = TodoStorageService.shared.loadTodos()
print("Loaded \(loadedTodos.count) todos:")
for todo in loadedTodos {
    print("- \(todo.title) (completed: \(todo.isCompleted))")
}

// Verify directory exists
let expectedURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    .first?
    .appendingPathComponent("TodoList")
    .appendingPathComponent("todos.json")

if let url = expectedURL {
    let directory = url.deletingLastPathComponent()
    print("\n3. Verifying directory exists...")
    if FileManager.default.fileExists(atPath: directory.path) {
        print("✅ Directory exists: \(directory)")
    } else {
        print("❌ Directory does not exist")
    }
    
    // Verify file exists
    if FileManager.default.fileExists(atPath: url.path) {
        print("✅ File exists: \(url)")
        let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64
        if let size = fileSize {
            print("   File size: \(size) bytes")
        }
    } else {
        print("❌ File does not exist")
    }
}

print("\nTest completed!")
