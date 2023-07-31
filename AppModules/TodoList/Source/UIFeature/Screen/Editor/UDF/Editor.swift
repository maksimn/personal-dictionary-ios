//
//  Editor.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 18.01.2023.
//

import ComposableArchitecture
import Foundation

struct Editor: Reducer {

    struct State: Equatable {
        var mode = EditorMode.create
        var todo = Todo()
        var savedTodo: Todo?
        var isDeadlinePickerHidden = true
        var keyboard = KeyboardUDF.State()

        var canBeSaved: Bool {
            let isStateAfterSaving = mode == .edit && todo == savedTodo

            return !isInitialState && !isStateAfterSaving
        }

        var canBeDeleted: Bool {
            !isInitialState
        }

        private var isInitialState: Bool {
            let empty = Todo()

            return mode == .create &&
                savedTodo == nil &&
                todo.text == empty.text &&
                todo.priority == empty.priority &&
                todo.deadline == empty.deadline
        }
    }

    enum Action: Equatable {
        case initWith(todo: Todo?)
        case close
        case textChanged(String)
        case priorityChanged(TodoPriority)
        case deadlineChanged(Date?)
        case toggleDeadlinePickerVisibility
        case saveTodo(Todo, EditorMode)
        case deleteTodo(Todo)
        case keyboard(KeyboardUDF.Action)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        Scope(state: \.keyboard, action: /Action.keyboard) {
            KeyboardUDF()
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .textChanged(let text):
            state.todo = state.todo.update(text: text)

        case .priorityChanged(let priority):
            state.todo = state.todo.update(priority: priority)

        case .deadlineChanged(let deadline):
            state.todo = state.todo.update(deadline: deadline)

        case .toggleDeadlinePickerVisibility:
            state.isDeadlinePickerHidden.toggle()

        case .saveTodo:
            state.mode = .edit
            state.savedTodo = state.todo

        case .deleteTodo:
            state = State()

        default:
            break
        }

        return .none
    }
}

enum EditorMode { case create, edit }
