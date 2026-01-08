import Foundation

final class TodoListViewModel: ObservableObject {
    @Published private(set) var todos: [Todo] = []

    private let storage = TodoStorageService.shared

    init() {
        loadTodos()
    }

    func addTodo(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let todo = Todo(title: trimmedTitle)
        todos.append(todo)
        sortTodos()
        saveTodos()
    }

    func toggleTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[index].isCompleted.toggle()
        sortTodos()
        saveTodos()
    }

    func deleteTodo(_ todo: Todo) {
        todos.removeAll { $0.id == todo.id }
        saveTodos()
    }

    func deleteTodos(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        saveTodos()
    }

    private func loadTodos() {
        todos = storage.loadTodos()
        sortTodos()
    }

    private func saveTodos() {
        storage.saveTodos(todos)
    }

    private func sortTodos() {
        // Sort todos: incomplete first, then completed
        todos.sort { a, b in
            if a.isCompleted == b.isCompleted {
                // If both have the same completion status, preserve their relative order
                return true
            }
            // Incomplete todos come first
            return !a.isCompleted
        }
    }
}
