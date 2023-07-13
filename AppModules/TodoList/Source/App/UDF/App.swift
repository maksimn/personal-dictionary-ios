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
        case start
        case getRemoteTodos
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
        case .start:
            return start()

        case .updateTodos(let todos):
            state.mainList.todos = todos
            state.mainList.completedTodoCount = todos.filter({ $0.isCompleted }).count
            return .none

        case .getRemoteTodos:
            return getRemoteTodos(state)

        case .update(let todo):
            return update(todo, state)

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

                do {
                    try await cache.replaceWith(todos)
                } catch {
                    await send(.error(error))
                }
            }

        case .syncWithRemoteTodosResult(.failure):
            return .send(.networkIndicator(.decrementNetworkRequestCount))

        default:
            return .none
        }
    }

    private func reduceInto(_ state: inout State, mainListAction action: MainList.Action) -> EffectTask<Action> {
        switch action {
        case .createTodo(let todo):
            return create(todo, state)

        case .toggleTodoCompletion(let todo):
            return .send(.update(todo.update(isCompleted: !todo.isCompleted)))

        case .deleteTodo(let todo):
            return delete(todo, state)

        case .editor(.saveTodo(let todo, let mode)):
            return editor(save: todo, mode: mode, state)

        case .editor(.deleteTodo(let todo)):
            return delete(todo, state)

        default:
            return .none
        }
    }

    private func editor(save todo: Todo, mode: EditorMode, _ state: State) -> EffectTask<Action> {
        switch mode {
        case .create:
            return create(todo, state)

        case .edit:
            return update(todo, state)
        }
    }

    private func create(_ todo: Todo, _ state: State) -> EffectTask<Action> {
        make(todo, dbOp: { try await cache.insert($0) }, serviceOp: { try await service.createRemote($0) }, state)
    }

    private func update(_ todo: Todo, _ state: State) -> EffectTask<Action> {
        make(todo, dbOp: { try await cache.update($0) }, serviceOp: { try await service.updateRemote($0) }, state)
    }

    private func delete(_ todo: Todo, _ state: State) -> EffectTask<Action> {
        if state.networkIndicator.pendingRequestCount > 0 || isDirty() {
            return .run { send in
                do {
                    try await cache.delete(todo)
                    try await deadCache.insert(Tombstone(todoId: todo.id, deletedAt: currentDate()))
                } catch {
                    await send(.error(error))
                }

                if state.networkIndicator.pendingRequestCount == 0 {
                    await send(.sync(.syncWithRemoteTodos))
                }
            }
        }

        return .run { send in
            try await cache.delete(todo)
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

    private func make(_ todo: Todo,
                      dbOp: @escaping (Todo) async throws -> Void,
                      serviceOp: @escaping (Todo) async throws -> Void,
                      _ state: State) -> EffectTask<Action> {
        let dirtyTodo = todo.update(isDirty: true)
        let cleanTodo = todo.update(isDirty: false)

        if state.networkIndicator.pendingRequestCount > 0 || isDirty() {
            return .run { send in
                do {
                    try await dbOp(dirtyTodo)
                } catch {
                    await send(.error(error))
                }

                if state.networkIndicator.pendingRequestCount == 0 {
                    await send(.sync(.syncWithRemoteTodos))
                }
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
                await send(.error(error))
            }
        }
    }

    private func start() -> EffectTask<Action> {
        .run { send in
            do {
                let todos = try cache.todos

                await send(.updateTodos(todos))

                if isDirty() {
                    await send(.sync(.syncWithRemoteTodos))
                } else {
                    await send(.getRemoteTodos)
                }
            } catch {
                return await send(.error(error))
            }
        }
    }

    private func getRemoteTodos(_ state: State) -> EffectTask<Action> {
        if state.networkIndicator.pendingRequestCount > 0 {
            return .none
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
    }

    private func isDirty() -> Bool {
        cache.isDirty || !deadCache.isEmpty
    }
}
