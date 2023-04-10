//
//  MainList.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 01.02.2023.
//

import ComposableArchitecture
import Foundation

struct App: ReducerProtocol {

    let loadCachedTodosEffect: Effect
    let getRemoteTodosEffect: Effect
    let replaceAllTodosInCacheEffect: TodoListEffect
    let createTodoEffect: TodoEffect
    let updateTodoEffect: TodoEffect
    let deleteTodoEffect: TodoEffect

    struct State: Equatable {
        var mainList = MainList.State()
        var networkIndicator = NetworkIndicator.State()
    }

    enum Action {
        case cachedTodosLoaded(todos: [Todo])

        case getRemoteTodosStart
        case getRemoteTodosSuccess(todos: [Todo])
        case getRemoteTodosError(Error)

        case syncWithRemoteTodosStart
        case syncWithRemoteTodosSuccess(todos: [Todo])
        case syncWithRemoteTodosError(Error)

        case mainList(MainList.Action)
        case networkIndicator(NetworkIndicator.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        Scope(state: \.mainList, action: /Action.mainList) {
            MainList()
        }
        Scope(state: \.networkIndicator, action: /Action.networkIndicator) {
            NetworkIndicator()
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .cachedTodosLoaded(let todos):
            update(state: &state, with: todos)

        case .getRemoteTodosSuccess(let todos):
            return updateAndSaveInCache(state: &state, todos: todos)

        case .syncWithRemoteTodosSuccess(let todos):
            return updateAndSaveInCache(state: &state, todos: state.mainList.todos.mergeWith(todos))

        case .mainList(let action):
            return reduceInto(&state, mainListAction: action)

        default:
            return .none
        }

        return .none
    }

    private func reduceInto(_ state: inout State, mainListAction action: MainList.Action) -> EffectTask<Action> {
        switch action {
        case .loadCachedTodos:
            return loadCachedTodosEffect.run()

        case .getRemoteTodos:
            return getRemoteTodosEffect.run()

        case .createTodo(let todo):
            return createTodoEffect.run(todo: todo)

        case .toggleTodoCompletion(let todo):
            return updateTodoEffect.run(todo: todo.update(isCompleted: !todo.isCompleted))

        case .deleteTodo(let todo):
            return deleteTodoEffect.run(todo: todo)

        case .editor(.saveTodo(let todo, let mode)):
            switch mode {
            case .create:
                return createTodoEffect.run(todo: todo)

            case .edit:
                return updateTodoEffect.run(todo: todo)
            }

        case .editor(.deleteTodo(let todo)):
            return deleteTodoEffect.run(todo: todo)

        default:
            return .none
        }
    }

    private func update(state: inout State, with todos: [Todo]) {
        state.mainList.todos = todos
        state.mainList.completedTodoCount = todos.filter({ $0.isCompleted }).count
    }

    private func updateAndSaveInCache(state: inout State, todos: [Todo]) -> EffectTask<Action> {
        update(state: &state, with: todos)

        return replaceAllTodosInCacheEffect.run(todoList: todos)
    }
}
