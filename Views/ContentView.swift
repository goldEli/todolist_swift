import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var newTodoTitle = ""

    var body: some View {
        VStack(spacing: 0) {
            headerView
            addTodoView

            if viewModel.todos.isEmpty {
                emptyStateView
            } else {
                todoListView
            }
        }
        .frame(minWidth: 400, minHeight: 500)
        .padding()
    }

    private var headerView: some View {
        HStack {
            Text("Todo List")
                .font(.title2)
                .fontWeight(.semibold)

            Spacer()

            Text("\(viewModel.todos.filter { !$0.isCompleted }.count) remaining")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 16)
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No todos yet")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Add a todo to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var todoListView: some View {
        List {
            ForEach(viewModel.todos) { todo in
                TodoRowView(todo: todo, onToggle: {
                    viewModel.toggleTodo(todo)
                }, onDelete: {
                    viewModel.deleteTodo(todo)
                })
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            }
            .onDelete { offsets in
                viewModel.deleteTodos(at: offsets)
            }
        }
        .listStyle(.plain)
    }

    private var addTodoView: some View {
        HStack(spacing: 8) {
            TextField("Add a new todo", text: $newTodoTitle)
                .textFieldStyle(.plain)
                .onSubmit {
                    addTodo()
                }

            Button(action: addTodo) {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .disabled(newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.top, 16)
    }

    private func addTodo() {
        let trimmedTitle = newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        viewModel.addTodo(title: trimmedTitle)
        newTodoTitle = ""
    }
}

struct TodoRowView: View {
    let todo: Todo
    let onToggle: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onDelete) {
                Image(systemName: "trash.circle.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
            .opacity(0.7)
            .frame(width: 30)

            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(todo.isCompleted ? .accentColor : .secondary)
            }
            .buttonStyle(.plain)
            .frame(width: 30)

            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .secondary : .primary)
                .lineLimit(2)

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onToggle()
        }
    }
}
