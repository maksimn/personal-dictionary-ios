//
//  App.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 01.02.2023.
//

import ComposableArchitecture
import Foundation

struct App: ReducerProtocol {

    let syncConfig: SyncConfig
    let cache: TodoListCache
    let deadCache: DeadCache
    let service: TodoListService
    let currentDate: () -> Date

    struct State: Equatable {
        var mainList = MainList.State()
        var networkIndicator = NetworkIndicator.State()
        var sync: Sync.State
    }

    enum Action {
        case update(Todo)
        case updateTodos([Todo])
        case mainList(MainList.Action)
        case networkIndicator(NetworkIndicator.Action)
        case sync(Sync.Action)
        case error(Error)
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
        Scope(state: \.sync, action: /Action.sync) {
            Sync(config: syncConfig)
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .updateTodos(let todos):
            state.mainList.todos = todos
            state.mainList.completedTodoCount = todos.filter({ $0.isCompleted }).count
            return .none

        case .update(let todo):
            return update(todo)

        case .mainList(let action):
            return reduceInto(&state, mainListAction: action)

        case .sync(let action):
            return reduceInto(&state, syncAction: action)

        default:
            return .none
        }
    }

    private func reduceInto(_ state: inout State, syncAction action: Sync.Action) -> EffectTask<Action> {
        switch action {
        case .syncWithRemoteTodos:
            return .send(.networkIndicator(.incrementNetworkRequestCount))

        case .syncWithRemoteTodosResult(.success(let todos)):
            return .run { send in
                await send(.networkIndicator(.decrementNetworkRequestCount))
                await send(.updateTodos(todos))
            }

        case .syncWithRemoteTodosResult(.failure):
            return .send(.networkIndicator(.decrementNetworkRequestCount))

        default:
            return .none
        }
    }

    private func reduceInto(_ state: inout State, mainListAction action: MainList.Action) -> EffectTask<Action> {
        switch action {
        case .loadCachedTodos:
            return loadCachedTodos()

        case .getRemoteTodos:
            return getRemoteTodos()

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

    private func isDirty() throws -> Bool {
        try cache.dirtyTodos.count > 0 || (try deadCache.items.count) > 0
    }

    private func create(_ todo: Todo) -> EffectTask<Action> {
        make(todo, dbOp: { try await cache.insert($0) }, serviceOp: { try await service.createRemote($0) })
    }

    private func update(_ todo: Todo) -> EffectTask<Action> {
        make(todo, dbOp: { try await cache.update($0) }, serviceOp: { try await service.updateRemote($0) })
    }

    private func delete(_ todo: Todo) -> EffectTask<Action> {
        .run { send in
            try await cache.delete(todo)

            do {
                if try isDirty() {
                    try await deadCache.insert(Tombstone(todoId: todo.id, deletedAt: currentDate()))
                    return await send(.sync(.syncWithRemoteTodos))
                }
            } catch {
                return await send(.error(error))
            }

            await send(.networkIndicator(.incrementNetworkRequestCount))

            do {
                try await service.deleteRemote(todo)
                await send(.networkIndicator(.decrementNetworkRequestCount))
            } catch {
                await send(.networkIndicator(.decrementNetworkRequestCount))
                try await deadCache.insert(Tombstone(todoId: todo.id, deletedAt: currentDate()))
                await send(.error(error))
            }
        }
    }

    private func make(_ todo: Todo, dbOp: @escaping (Todo) async throws -> Void,
                      serviceOp: @escaping (Todo) async throws -> Void) -> EffectTask<Action> {
        let dirtyTodo = todo.update(isDirty: true)
        let cleanTodo = todo.update(isDirty: false)

        do {
            if try isDirty() {
                return .run { send in
                    try await dbOp(dirtyTodo)
                    await send(.sync(.syncWithRemoteTodos))
                }
            }
        } catch {
            return .send(.error(error))
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
                await send(.error(error))
            }
        }
    }

    private func loadCachedTodos() -> EffectTask<Action> {
        do {
            let todos = try cache.todos

            return .send(.updateTodos(todos))
        } catch {
            return .send(.error(error))
        }
    }

    private func getRemoteTodos() -> EffectTask<Action> {
        do {
            if try isDirty() {
                return .send(.sync(.syncWithRemoteTodos))
            }

            return .run { send in
                do {
                    await send(.networkIndicator(.incrementNetworkRequestCount))
                    let todos = try await service.getTodos()

                    await send(.updateTodos(todos))
                    try await cache.replaceWith(todos)
                    await send(.networkIndicator(.decrementNetworkRequestCount))
                } catch {
                    await send(.networkIndicator(.decrementNetworkRequestCount))
                    await send(.error(error))
                }
            }
        } catch {
            return .send(.error(error))
        }
    }
}
