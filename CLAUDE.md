# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **SwiftUI macOS application** that implements a simple Todo List manager. The app allows users to add, complete, and delete todos with data persistence to a JSON file.

## Architecture

The project follows the **MVVM (Model-View-ViewModel) pattern**:

- **Models** (`Models/Todo.swift`): Data structures - `Todo` entity with id, title, and completion status
- **Views** (`Views/ContentView.swift`): SwiftUI UI components - main view with list and todo row views
- **ViewModels** (`ViewModels/TodoListViewModel.swift`): Business logic layer - manages todo operations and state
- **Services** (`Services/TodoStorageService.swift`): Data persistence layer - handles saving/loading todos to JSON

**App Entry Point**: `TodoListApp.swift` - Creates the main window with `ContentView`

## Build System

The project uses **XCLemma** (defined in `project.yml`) which generates an Xcode project (`TodoList.xcodeproj`). The project configuration:
- Swift 5.9
- macOS 13.0+ deployment target
- Xcode 15.0
- App Bundle ID: `com.todolist.app`

## Common Commands

### Building the App
```bash
# Build the app
xcodebuild -project TodoList.xcodeproj -scheme TodoList build

# Build for Release
xcodebuild -project TodoList.xcodeproj -scheme TodoList -configuration Release build
```

### Running the App
```bash
# Run the app
xcodebuild -project TodoList.xcodeproj -scheme TodoList run

# Or open in Xcode for interactive development
open TodoList.xcodeproj
```

### Testing the Storage Service
```bash
# Run the test script that verifies the TodoStorageService fix
swift TestStorageFix.swift
```

### Cleaning Build
```bash
# Clean build artifacts
xcodebuild -project TodoList.xcodeproj clean
```

## Data Persistence

Todos are saved to `~/Library/Application Support/TodoList/todos.json` using JSON encoding. The `TodoStorageService` ensures the directory exists before writing (see the fix in `Services/TodoStorageService.swift:35-36`).

## Development Notes

- **No unit tests present** - The `TestStorageFix.swift` is a standalone test script for verifying storage behavior
- **No linting tools configured** - SwiftLint is not installed
- **Minimal dependencies** - Uses only SwiftUI/Foundation frameworks
- **Sorted todos** - Incomplete todos appear first, completed todos appear last

## Key Implementation Details

- Todos are sorted on every mutation (add/toggle/delete)
- The app uses a singleton pattern for `TodoStorageService.shared`
- Input validation prevents empty todos from being added
- The UI uses a list with custom row views and supports swipe-to-delete
