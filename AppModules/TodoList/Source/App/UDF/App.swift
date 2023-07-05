//
//  App.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 01.02.2023.
//

import ComposableArchitecture
import Foundation

struct App: ReducerProtocol {

    let cache: TodoListCache
    let deadCache: DeadCache
    let service: TodoListService
    let currentDate: () -> Date

    struct State: Equatable {
        var mainList = MainList.State()
        var networkIndicator = NetworkIndicator.State()
    }

    enum Action {
        case syncWithRemoteTodos
        case update(Todo)
        case updateTodos([Todo])
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
        case .updateTodos(let todos):
            state.mainList.todos = todos
            state.mainList.completedTodoCount = todos.filter({ $0.isCompleted }).count
            return .none

        case .syncWithRemoteTodos:
            return make(serviceOp: {
                let deleted = Array(Set(deadCache.items.map { $0.todoId }))
                let dirtyTodos = cache.todos.filter { $0.isDirty }
                let todos = try await service.syncWithRemote(deleted, dirtyTodos)
                try await deadCache.clear()
                return todos
            })

        case .update(let todo):
            return update(todo)

        case .mainList(let action):
            return reduceInto(&state, mainListAction: action)

        default:
            return .none
        }
    }

    private func reduceInto(_ state: inout State, mainListAction action: MainList.Action) -> EffectTask<Action> {
        switch action {
        case .loadCachedTodos:
            return .send(.updateTodos(cache.todos))

        case .getRemoteTodos:
            if cache.isDirty {
                return .send(.syncWithRemoteTodos)
            }

            return make(serviceOp: { try await service.getTodos() })

        case .createTodo(let todo):
            return create(todo)

        case .toggleTodoCompletion(let todo):
            return .send(.update(todo.update(isCompleted: !todo.isCompleted)))

        case .deleteTodo(let todo):
            return delete(todo)

        case .editor(.saveTodo(let todo, let mode)):
            return editor(save: todo, mode: mode)

        case .editor(.deleteTodo(let todo)):
            return delete(todo)

        default:
            return .none
        }
    }

    private func editor(save todo: Todo, mode: EditorMode) -> EffectTask<Action> {
        switch mode {
        case .create:
            return create(todo)

        case .edit:
            return update(todo)
        }
    }

    private func create(_ todo: Todo) -> EffectTask<Action> {
        return make(todo, dbOp: { try await cache.insert($0) }, serviceOp: { try await service.createRemote($0) })
    }

    private func update(_ todo: Todo) -> EffectTask<Action> {
        return make(todo, dbOp: { try await cache.update($0) }, serviceOp: { try await service.updateRemote($0) })
    }

    private func delete(_ todo: Todo) -> EffectTask<Action> {
        return .run { send in
            try await cache.delete(todo)

            if cache.isDirty {
                try await deadCache.insert(Tombstone(todoId: todo.id, deletedAt: currentDate()))
                return await send(.syncWithRemoteTodos)
            }

            await send(.networkIndicator(.incrementNetworkRequestCount))

            do {
                try await service.deleteRemote(todo)
                await send(.networkIndicator(.decrementNetworkRequestCount))
            } catch {
                await send(.networkIndicator(.decrementNetworkRequestCount))
                try await deadCache.insert(Tombstone(todoId: todo.id, deletedAt: currentDate()))
                throw error
            }
        }
    }

    private func make(serviceOp: @escaping () async throws -> [Todo]) -> EffectTask<Action> {
        return .run { send in
            do {
                await send(.networkIndicator(.incrementNetworkRequestCount))
                let todos = try await serviceOp()

                await send(.updateTodos(todos))
                try await cache.replaceWith(todos)
                await send(.networkIndicator(.decrementNetworkRequestCount))
            } catch {
                await send(.networkIndicator(.decrementNetworkRequestCount))
                throw error
            }
        }
    }

    private func make(_ todo: Todo, dbOp: @escaping (Todo) async throws -> Void,
                      serviceOp: @escaping (Todo) async throws -> Void) -> EffectTask<Action> {
        let dirtyTodo = todo.update(isDirty: true)
        let cleanTodo = todo.update(isDirty: false)

        if cache.isDirty {
            return .run { send in
                try await dbOp(dirtyTodo)
                await send(.syncWithRemoteTodos)
            }
        }

        return .run { send in
            try await dbOp(dirtyTodo)
            await send(.networkIndicator(.incrementNetworkRequestCount))
            do {
                try await serviceOp(cleanTodo)
                try await cache.update(cleanTodo)
                await send(.networkIndicator(.decrementNetworkRequestCount))
            } catch {
                await send(.networkIndicator(.decrementNetworkRequestCount))
                throw error
            }
        }
    }
}
