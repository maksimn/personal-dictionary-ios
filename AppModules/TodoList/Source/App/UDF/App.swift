//
//  App.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 01.02.2023.
//

import ComposableArchitecture
import CoreModule
import Foundation

// The root reducer. It is responsible for all side-effects of TodoList.
struct App: ReducerProtocol {

    let syncConfig: SyncConfig
    let cache: TodoListCache
    let service: TodoListService
    let tombstones: TombstoneInsertable & Clearable
    let dirtyStateStatus: DirtyStateStatus
    let currentDate: () -> Date

    struct State: Equatable {
        var mainList = MainList.State()
        var networkIndicator = NetworkIndicator.State()
        var sync: Sync.State
    }

    enum Action: Equatable {
        case start
        case getRemoteTodos
        case update(Todo)
        case mainList(MainList.Action)
        case networkIndicator(NetworkIndicator.Action)
        case sync(Sync.Action)
        case error(WithError)
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
                await send(.mainList(.updateTodos(todos)))

                do {
                    try await cache.replaceWith(todos)
                    try await tombstones.clear()
                } catch {
                    await send(.error(WithError(error)))
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
        make(todo,
             localOp: { try await cache.insert($0) },
             remoteOp: {
                 try await service.createRemote($0)
                 try await cache.update($0)
             }, state)
    }

    private func update(_ todo: Todo, _ state: State) -> EffectTask<Action> {
        make(todo,
             localOp: { try await cache.update($0) },
             remoteOp: {
                 try await service.updateRemote($0)
                 try await cache.update($0)
             }, state)
    }

    private func delete(_ todo: Todo, _ state: State) -> EffectTask<Action> {
        make(todo,
             localOp: { try await cache.delete($0) },
             remoteOp: { try await service.deleteRemote($0) },
             remoteOpFailure: { try await tombstones.insert(Tombstone(todoId: $0.id, deletedAt: currentDate())) },
             state)
    }

    private func make(_ todo: Todo,
                      localOp: @escaping (Todo) async throws -> Void,
                      remoteOp: @escaping (Todo) async throws -> Void,
                      remoteOpFailure: @escaping (Todo) async throws -> Void = { _ in },
                      _ state: State) -> EffectTask<Action> {
        let dirtyTodo = todo.update(isDirty: true)
        let cleanTodo = todo.update(isDirty: false)

        if state.networkIndicator.pendingRequestCount > 0 || dirtyStateStatus.isDirty {
            return .run { send in
                do {
                    try await localOp(dirtyTodo)
                } catch {
                    await send(.error(WithError(error)))
                }

                if state.networkIndicator.pendingRequestCount == 0 {
                    await send(.sync(.syncWithRemoteTodos))
                }
            }
        }

        return .run { send in
            try await localOp(dirtyTodo)
            await send(.networkIndicator(.incrementNetworkRequestCount))
            do {
                try await remoteOp(cleanTodo)
                await send(.networkIndicator(.decrementNetworkRequestCount))
            } catch {
                do {
                    try await remoteOpFailure(dirtyTodo)
                } catch {
                    await send(.error(WithError(error)))
                }
                await send(.networkIndicator(.decrementNetworkRequestCount))
                await send(.error(WithError(error)))
            }
        }
    }

    private func start() -> EffectTask<Action> {
        .run { send in
            do {
                let todos = try cache.todos

                await send(.mainList(.updateTodos(todos)))

                if dirtyStateStatus.isDirty {
                    await send(.sync(.syncWithRemoteTodos))
                } else {
                    await send(.getRemoteTodos)
                }
            } catch {
                return await send(.error(WithError(error)))
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

                await send(.mainList(.updateTodos(todos)))
                try await cache.replaceWith(todos)
                await send(.networkIndicator(.decrementNetworkRequestCount))
            } catch {
                await send(.networkIndicator(.decrementNetworkRequestCount))
                await send(.error(WithError(error)))
            }
        }
    }
}
