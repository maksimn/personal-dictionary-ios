//
//  MainList.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 08.02.2023.
//

import ComposableArchitecture

struct MainList: Reducer {

    struct State: Equatable {
        var todos: [Todo] = []
        var completedTodoCount = 0
        var areCompletedTodosVisible = false
        var todoText = ""
        var editor: Editor.State?
        var keyboard = KeyboardUDF.State()
    }

    enum Action: Equatable {
        case updateTodos([Todo])
        case todoTextChanged(String)
        case createTodo(todo: Todo)
        case toggleTodoCompletion(todo: Todo)
        case deleteTodo(todo: Todo)
        case editor(Editor.Action)
        case showButton(ShowButton.Action)
        case keyboard(KeyboardUDF.Action)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        .ifLet(\.editor, action: /Action.editor) {
            Editor()
        }
        Scope(state: \.keyboard, action: /Action.keyboard) {
            KeyboardUDF()
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .updateTodos(let todos):
            state.todos = todos
            state.completedTodoCount = todos.filter({ $0.isCompleted }).count

        case .createTodo(let todo):
            state.todos.append(todo)

        case .todoTextChanged(let text):
            state.todoText = text

        case .toggleTodoCompletion(let todo):
            reduce(into: &state, toggleCompletionFor: todo)

        case .deleteTodo(let todo):
            reduce(into: &state, delete: todo)

        case .editor(let action):
            reduceInto(&state, editorAction: action)

        case .showButton:
            state.areCompletedTodosVisible.toggle()

        default:
            break
        }

        return .none
    }

    private func reduceInto(_ state: inout State, editorAction: Editor.Action) {
        switch editorAction {
        case .initWith(let todo):
            let emptyEditorState = Editor.State()

            if let todo = todo {
                state.editor = Editor.State(
                    mode: .edit,
                    todo: todo,
                    savedTodo: todo,
                    isDeadlinePickerHidden: emptyEditorState.isDeadlinePickerHidden
                )
            } else {
                state.editor = emptyEditorState
            }

        case .saveTodo(let todo, _):
            if let index = state.todos.firstIndex(where: { $0.id == todo.id }) {
                state.todos[index] = todo
            } else {
                state.todos.append(todo)
            }

        case .deleteTodo(let todo):
            reduce(into: &state, delete: todo)

        case .close:
            state.editor = nil

        default:
            break
        }
    }

    private func reduce(into state: inout State, delete todo: Todo) {
        guard let index = state.todos.firstIndex(where: { $0.id == todo.id }) else { return }

        state.todos.remove(at: index)

        if todo.isCompleted && state.completedTodoCount > 0 {
            state.completedTodoCount -= 1
        }
    }

    private func reduce(into state: inout State, toggleCompletionFor todo: Todo) {
        guard let index = state.todos.firstIndex(where: { $0.id == todo.id }) else { return }
        let newTodo = todo.update(isCompleted: !todo.isCompleted)

        state.todos[index] = newTodo

        if newTodo.isCompleted {
            state.completedTodoCount += 1
        } else if state.completedTodoCount > 0 {
            state.completedTodoCount -= 1
        }
    }
}
